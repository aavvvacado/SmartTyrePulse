abstract class TyreEvent {}

class SelectTyreEvent extends TyreEvent {
  final String tyreId;
  SelectTyreEvent({required this.tyreId});
}
