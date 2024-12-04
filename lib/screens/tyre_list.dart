import 'package:flutter/material.dart';

import '../models/tyre_model.dart';
import '../repositories/tyre_repository.dart';

class TyreListPage extends StatefulWidget {
  final String dumperName;

  TyreListPage({required this.dumperName});

  @override
  _TyreListPageState createState() => _TyreListPageState();
}

class _TyreListPageState extends State<TyreListPage> {
  final TyreRepository tyreRepository = TyreRepository();
  Tyre? selectedTyre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dumper ${widget.dumperName}'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Tyre>>(
          future: tyreRepository.getTyres(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No tyres available.'));
            }

            final tyres = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepPurpleAccent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Tyre>(
                      hint: Text('Select Tyre'),
                      value: selectedTyre,
                      onChanged: (Tyre? newValue) {
                        setState(() {
                          selectedTyre = newValue;
                        });
                      },
                      isExpanded: true,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      iconSize: 30,
                      icon: Icon(Icons.arrow_drop_down_circle,
                          color: Colors.deepPurpleAccent),
                      items: tyres.map<DropdownMenuItem<Tyre>>((Tyre tyre) {
                        return DropdownMenuItem<Tyre>(
                          value: tyre,
                          child: Row(
                            children: [
                              Icon(Icons.data_saver_off_sharp,
                                  color: Colors.deepPurpleAccent),
                              SizedBox(width: 10),
                              Text(tyre.name, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        );
                      }).toList(),
                      // Ensure the dropdown is large enough to fit the content
                      isDense: false,
                      dropdownColor: Colors.white,
                      // This will ensure that the dropdown fits properly
                      itemHeight: 60.0,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                if (selectedTyre != null)
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.speed, 'Pressure',
                            '${selectedTyre!.pressure} PSI'),
                        Divider(color: Colors.black),
                        _buildDetailRow(
                            Icons.speed, 'TKPH', '${selectedTyre!.tkph}'),
                        Divider(color: Colors.black),
                        _buildDetailRow(Icons.all_inclusive, 'Payload',
                            '${selectedTyre!.payload} kg'),
                        Divider(color: Colors.black),
                        _buildDetailRow(Icons.build, 'Wear & Tear Rate',
                            '${selectedTyre!.wearTearRate}%'),
                        Divider(color: Colors.black),
                        _buildDetailRow(Icons.access_time, 'Life Span',
                            '${selectedTyre!.lifeSpan} hrs'),
                        Divider(color: Colors.black),
                        _buildDetailRow(Icons.thermostat_rounded, 'Temperature',
                            '${selectedTyre!.temperature} °C'),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.orangeAccent),
              SizedBox(width: 8),
              Text(
                '$label:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                color: Colors.orangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
