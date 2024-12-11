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
        title: Text('Dumper: ${widget.dumperName}'),
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
                  'Pressure Monitoring',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Column(
                    children: [
                      // First row with 2 circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTyreCircle(tyres[0]),
                          _buildTyreCircle(tyres[1]),
                        ],
                      ),
                      SizedBox(height: 32),
                      Divider(thickness: 2, color: Colors.grey),
                      SizedBox(height: 32),
                      // Second row with 4 circles adjusted to fit in one line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: tyres
                            .skip(2)
                            .take(4)
                            .map((tyre) =>
                                Flexible(child: _buildTyreCircle(tyre)))
                            .toList(),
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
                fontSize: 12,
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
    if (tyre.pressure > 100 || tyre.temperature > 50) {
      return Colors.red;
    } else if (tyre.pressure > 80 || tyre.temperature > 40) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
