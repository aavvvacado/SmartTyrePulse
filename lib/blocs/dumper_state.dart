import '../models/dumper_model.dart';

abstract class DumperState {}

class DumperInitialState extends DumperState {}

class LoadingDumperState extends DumperState {}

class LoadedDumperState extends DumperState {
  final List<Dumper> dumpers;
  LoadedDumperState({required this.dumpers});
}

class DumperSelectedState extends DumperState {
  final String selectedDumper;
  DumperSelectedState({required this.selectedDumper});
}
