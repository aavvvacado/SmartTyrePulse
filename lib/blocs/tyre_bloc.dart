import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/tyre_model.dart';
import 'tyre_event.dart';
import 'tyre_state.dart';

class TyreBloc extends Bloc<TyreEvent, TyreState> {
  TyreBloc() : super(TyreInitialState());

  @override
  Stream<TyreState> mapEventToState(TyreEvent event) async* {
    if (event is SelectTyreEvent) {
      // Create a Tyre object with the updated model attributes
      Tyre tyre = Tyre(
        name: 'Tyre 1',
        pressure: 32.0,
        temperature: 70,
      );

      // Yield the new state with the selected tyre
      yield TyreSelectedState(selectedTyre: tyre);
    }
  }
}
