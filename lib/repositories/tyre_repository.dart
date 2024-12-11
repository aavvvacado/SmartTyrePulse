import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/tyre_model.dart';

class TyreRepository {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref("UsersData/wmKpLeRocgRwhVf10Fe3cTlSlnw2");

  final _tyreStreamController = StreamController<List<Tyre>>.broadcast();

  Stream<List<Tyre>> get tyreStream => _tyreStreamController.stream;

  TyreRepository() {
    _listenToRealTimeUpdates();
  }

  void _listenToRealTimeUpdates() {
    _database.onValue.listen((event) {
      if (event.snapshot.exists) {
        try {
          final data = event.snapshot.value as Map;
          final List<Tyre> tyres = [
            Tyre(
              name: 'Front left',
              pressure: (data['pressure'] ?? 0).toDouble(),
              temperature: (data['temperature'] ?? 0).toDouble(),
            ),
            Tyre(
              name: 'Front right',
              pressure: 40.0,
              temperature: 35.0,
            ),
            Tyre(
              name: 'Rear L1',
              pressure: 42.0,
              temperature: 35.0,
            ),
            Tyre(
              name: 'Rear L2',
              pressure: 23.0,
              temperature: 15.0,
            ),
            Tyre(
              name: 'Rear R1',
              pressure: 36.0,
              temperature: 26.0,
            ),
            Tyre(
              name: 'Rear R2',
              pressure: 45.0,
              temperature: 15.0,
            ),
          ];

          _tyreStreamController.add(tyres);
        } catch (e) {
          print('Error processing real-time data: $e');
          _tyreStreamController.addError('Error processing data');
        }
      } else {
        print('No data found');
        _tyreStreamController.add([]);
      }
    }, onError: (error) {
      print('Real-time listener error: $error');
      _tyreStreamController.addError(error);
    });
  }

  void dispose() {
    _tyreStreamController.close();
  }
}
