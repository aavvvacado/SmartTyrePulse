abstract class DumperEvent {}

class LoadDumpersEvent extends DumperEvent {}

class SelectDumperEvent extends DumperEvent {
  final String dumperId;
  SelectDumperEvent({required this.dumperId});
}
