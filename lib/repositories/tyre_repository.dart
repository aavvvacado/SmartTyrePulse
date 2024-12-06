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
              name: 'left',
              pressure: (data['pressure'] ?? 0).toDouble(),
              temperature: (data['temperature'] ?? 0).toDouble(),
              tkph: 3000,
              payload: 5000.0,
              wearTearRate: 15.5,
              lifeSpan: 5000,
            ),
            Tyre(
              name: 'right',
              pressure: 40.0,
              temperature: 28.0,
              tkph: 3500,
              payload: 5500.0,
              wearTearRate: 12.0,
              lifeSpan: 4500,
            ),
            Tyre(
              name: 'rear left',
              pressure: 38.0,
              temperature: 32.0,
              tkph: 3200,
              payload: 5300.0,
              wearTearRate: 18.0,
              lifeSpan: 4700,
            ),
            Tyre(
              name: 'rear right',
              pressure: 38.0,
              temperature: 32.0,
              tkph: 3200,
              payload: 5300.0,
              wearTearRate: 18.0,
              lifeSpan: 4700,
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
