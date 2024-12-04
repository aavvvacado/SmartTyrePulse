import 'dart:async';

import '../models/tyre_model.dart';

class TyreRepository {
  // Simulate fetching tyre data from an API or local storage
  Future<List<Tyre>> getTyres() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Here you can replace this with actual Firebase fetch logic or other data sources.
    // For now, I’m using hardcoded default tyre data
    return [
      Tyre(
        name: 'left',
        pressure: 35.0,
        tkph: 3000,
        payload: 5000.0,
        wearTearRate: 15.5,
        lifeSpan: 5000,
        temperature: 30.0,
      ),
      Tyre(
        name: 'right',
        pressure: 40.0,
        tkph: 3500,
        payload: 5500.0,
        wearTearRate: 12.0,
        lifeSpan: 4500,
        temperature: 28.0,
      ),
      Tyre(
        name: 'Tyre 3',
        pressure: 38.0,
        tkph: 3200,
        payload: 5300.0,
        wearTearRate: 18.0,
        lifeSpan: 4700,
        temperature: 32.0,
      ),
      Tyre(
        name: 'Tyre 4',
        pressure: 38.0,
        tkph: 3200,
        payload: 5300.0,
        wearTearRate: 18.0,
        lifeSpan: 4700,
        temperature: 32.0,
      ),
    ];
  }
}
