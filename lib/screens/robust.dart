import 'dart:async'; // Import for Timer functionality
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RobustScreen extends StatefulWidget {
  @override
  _RobustScreenState createState() => _RobustScreenState();
}

class _RobustScreenState extends State<RobustScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref("UsersData/wmKpLeRocgRwhVf10Fe3cTlSlnw2");

  double pressure = 0.0;
  double awss = 0.0;
  double mean_load = 0.0;
  double load = 0.0;
  double rotations = 0.0;
  double distanceTravelled = 0.0;
  bool isParkingBrakeOn = false;
  bool isLoading = false;
  bool isUnloading = false;
  double totalDistance = 0.0;
  double wheel_rotations_loading = 0.0;
  double wheel_rotations_unloading = 0.0;

  double loadedTime = 0.0;
  double unloadedTime = 0.0;
  double loadedDistance = 0.0;
  double unloadedDistance = 0.0;
  double tkph = 0.0;
  double initialLoad = 0.0;
  double prevLoad = 0.0; // To store previous load value from Firebase
  double nextLoad = 0.0; // To store the new load value for comparison

  Timer? loadingTimer; // Changed to nullable and initialized as null
  Timer? unloadingTimer; // Changed to nullable and initialized as null

  bool timerStarted =
      false; // Flag to track whether the timer is already running

  // Fetch data from Firebase
  void _fetchData() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        print("Fetched Data: $data");

        setState(() {
          pressure = (data['pressure'] as num?)?.toDouble() ?? 0.0;
          load = (data['load'] as num?)?.toDouble() ?? 0.0;
          rotations = (data['wheel_rotations'] as num?)?.toDouble() ?? 0.0;
          wheel_rotations_loading =
              (data['wheel_rotations_loading'] as num?)?.toDouble() ?? 0.0;
          wheel_rotations_unloading =
              (data['wheel_rotations_unloading'] as num?)?.toDouble() ?? 0.0;
          isParkingBrakeOn = data['parking_brake'] ?? false;
          initialLoad = (data['initial_load'] as num?)?.toDouble() ?? 0.0;
          nextLoad = load; // Set nextLoad to the current load value

          // Assuming radius = 1 meter for wheel rotation distance calculation
          loadedDistance = 2 * pi * 0.5 * wheel_rotations_loading;
          unloadedDistance = 2 * pi * 0.5 * wheel_rotations_unloading;
          distanceTravelled = 2 * pi * 0.5 * rotations;
          totalDistance = loadedDistance + unloadedDistance;
        });

        _handleLoadingUnloadingState();
      } else {
        print("No data found in Firebase");
      }
    });
  }

  // Update the parking brake status in Firebase
  void _updateParkingBrakeStatus(bool value) {
    _database.update({'parking_brake': value});
  }

  // Handle loading/unloading based on parking brake status and load
  void _handleLoadingUnloadingState() {
    if (prevLoad != nextLoad) {
      if (isParkingBrakeOn) {
        if (nextLoad > prevLoad) {
          // Loading - Brake on and load is increasing
          _startLoadingState();
        } else if (nextLoad < prevLoad) {
          // Unloading - Brake on and load is decreasing
          _startUnloadingState();
        }
      } else {
        // Brake is off, check for load
        if (nextLoad > 0) {
          // Loading - Brake off and load is not zero
          _startLoadingState();
        } else if (nextLoad == 0) {
          // Unloading - Brake off and load is zero
          _startUnloadingState();
        }
      }
      setState(() {
        prevLoad = nextLoad; // Update prevLoad with current value
      });
    }
  }

  // Start the loading state
  void _startLoadingState() {
    setState(() {
      isLoading = true;
      isUnloading = false;
    });

    if (!timerStarted) {
      loadingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          loadedTime += 1;
        });
      });
      timerStarted = true;
    }
  }

  // Start the unloading state
  void _startUnloadingState() {
    setState(() {
      isUnloading = true;
      isLoading = false;
    });

    if (!timerStarted) {
      unloadingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          unloadedTime += 1;
        });
      });
      timerStarted = true;
    }
  }

  // Stop the timers when loading/unloading ends
  void _stopTimers() {
    loadingTimer?.cancel();
    unloadingTimer?.cancel();
    loadingTimer = null;
    unloadingTimer = null;
    timerStarted = false;
  }

  // Calculate TKPH based on loaded/unloaded data
  void _calculateTKPH() {
    setState(() {
      double totalDistance = loadedDistance + unloadedDistance;
      double totalTime = loadedTime + unloadedTime;

      awss = (totalTime > 0) ? (totalDistance / totalTime) : 0.0;
      mean_load = (loadedTime * load) * (unloadedTime * 2) / totalTime;

      tkph = mean_load * awss;
    });

    _database.update({
      'awss': awss.toStringAsFixed(2),
      'mean_load': mean_load.toStringAsFixed(2),
      'tkph': tkph.toStringAsFixed(2),
      'loading_time': loadedTime,
      'unloading_time': unloadedTime,
      'loaded_distance': loadedDistance,
      'unloaded_distance': unloadedDistance,
      'total_distance': loadedDistance + unloadedDistance,
      'total_time': loadedTime + unloadedTime,
    });
  }

  // When the "Reach destination and calculate TKPH" button is pressed
  void _onReachDestinationPressed() {
    _stopTimers();
    _calculateTKPH();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("TKPH Result",
              style: TextStyle(color: Colors.white, fontSize: 24)),
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.speed, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text("AWSS: ${awss.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.gavel, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text("Mean Tire Load: ${mean_load.toStringAsFixed(2)} kg",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text("TKPH Rating: ${tkph.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tyre Monitoring System'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isLoading ? Colors.orange : Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      isLoading ? "Loading Condition" : "Unloading Condition",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.speed, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Pressure: ${pressure.toStringAsFixed(2)} kPa",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.monitor_weight, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Load: ${load.toStringAsFixed(2)} kg",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.track_changes, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Total Distance: ${(totalDistance).toStringAsFixed(2)} m",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SwitchListTile(
                      title: Text('Parking Brake',
                          style: TextStyle(color: Colors.white)),
                      value: isParkingBrakeOn,
                      onChanged: (bool value) {
                        setState(() {
                          isParkingBrakeOn = value;
                          _updateParkingBrakeStatus(value);
                        });
                      },
                      activeColor: Colors.yellow,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onReachDestinationPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Reach Destination and Calculate TKPH',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
