import '../models/tyre_model.dart';

abstract class TyreState {}

class TyreInitialState extends TyreState {}

class TyreSelectedState extends TyreState {
  final Tyre selectedTyre;
  TyreSelectedState({required this.selectedTyre});
}
