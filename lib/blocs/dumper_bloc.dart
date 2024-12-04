import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/dumper_model.dart';
import 'dumper_event.dart';
import 'dumper_state.dart';

class DumperBloc extends Bloc<DumperEvent, DumperState> {
  DumperBloc() : super(DumperInitialState());

  @override
  Stream<DumperState> mapEventToState(DumperEvent event) async* {
    if (event is LoadDumpersEvent) {
      yield LoadingDumperState();
      await Future.delayed(Duration(seconds: 2));
      List<Dumper> dumpers = [
        Dumper(
            id: '1', name: 'Dumper 1', location: '', operator: '', status: ''),
        Dumper(
            id: '2', name: 'Dumper 2', location: '', operator: '', status: ''),
      ];
      yield LoadedDumperState(dumpers: dumpers);
    }

    if (event is SelectDumperEvent) {
      yield DumperSelectedState(selectedDumper: event.dumperId);
    }
  }
}
