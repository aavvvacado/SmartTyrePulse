import 'package:flutter/material.dart';

import '../models/tyre_model.dart';
import '../repositories/tyre_repository.dart';

class TyreCard extends StatelessWidget {
  final TyreRepository tyreRepository = TyreRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tyre>>(
      stream: tyreRepository.tyreStream, // Use the updated stream here
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Handle empty data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No tyres available.'));
        }

        final tyres = snapshot.data!;

        return ListView.builder(
          itemCount: tyres.length,
          itemBuilder: (context, index) {
            final tyre = tyres[index];

            return Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  tyre.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pressure: ${tyre.pressure.toStringAsFixed(2)} PSI',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      Text(
                        'Wear & Tear: ${tyre.wearTearRate.toStringAsFixed(2)}%',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      Text(
                        'Life Span: ${tyre.lifeSpan} hrs',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TKPH: ${tyre.tkph.toStringAsFixed(2)}',
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Payload: ${tyre.payload.toStringAsFixed(2)} kg',
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
