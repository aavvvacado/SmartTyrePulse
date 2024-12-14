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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.dumperName}'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Tyre>>(
          stream: tyreRepository.tyreStream,
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
              children: [
                Text(
                  'Pressure Dashboard',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Vertical Line connecting both rows (stops at second line)
                      Positioned(
                        top: 100, // Position starts at front tyres line
                        child: Container(
                          width: 8,
                          color: Colors.black,
                          height:
                              200, // Height adjusted to stop at rear tyres line
                        ),
                      ),
                      // Horizontal line for top row (front tyres)
                      Positioned(
                        top: 100,
                        left: 60,
                        right: 60,
                        child: Container(
                          height: 8,
                          color: Colors.black,
                        ),
                      ),
                      // Horizontal line for bottom row (rear tyres)
                      Positioned(
                        top: 300,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 8,
                          color: Colors.black,
                        ),
                      ),
                      // Front tyres
                      Positioned(
                        top: 60,
                        left: 60,
                        child: _buildTyreCircle(tyres[0]),
                      ),
                      Positioned(
                        top: 60,
                        right: 60,
                        child: _buildTyreCircle(tyres[1]),
                      ),
                      // Rear tyres
                      Positioned(
                        top: 260,
                        left: 20,
                        child: _buildTyreCircle(tyres[2]),
                      ),
                      Positioned(
                        top: 260,
                        left: 100,
                        child: _buildTyreCircle(tyres[3]),
                      ),
                      Positioned(
                        top: 260,
                        right: 100,
                        child: _buildTyreCircle(tyres[4]),
                      ),
                      Positioned(
                        top: 260,
                        right: 20,
                        child: _buildTyreCircle(tyres[5]),
                      ),
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

  Widget _buildTyreCircle(Tyre tyre) {
    Color statusColor = _getStatusColor(tyre);
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tyre.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${tyre.pressure} hPa',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white,
              ),
            ),
            Text(
              '${tyre.temperature} °C',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(Tyre tyre) {
    if (tyre.pressure < 948 || tyre.pressure > 952.5 || tyre.temperature > 40) {
      return Colors.red;
    } else if (tyre.pressure > 952) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
