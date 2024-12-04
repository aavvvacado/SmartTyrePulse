import '../models/dumper_model.dart';

class DumperRepository {
  // List of dumper objects, initially populated with dummy data.
  List<Dumper> _dumpers = [
    Dumper(
      id: 'D1',
      name: 'Dumper A',
      location: 'Mine 1',
      operator: 'John Doe',
      status: 'Operational',
    ),
    Dumper(
      id: 'D2',
      name: 'Dumper B',
      location: 'Mine 2',
      operator: 'Jane Smith',
      status: 'Under Care',
    ),
    Dumper(
      id: 'D3',
      name: 'Dumper C',
      location: 'Mine 3',
      operator: 'David Johnson',
      status: 'Operational',
    ),
    Dumper(
      id: 'D4',
      name: 'Dumper D',
      location: 'Mine 4',
      operator: 'Emily Davis',
      status: 'Idle',
    ),
  ];

  // Retrieve all dumpers
  List<Dumper> getDumpers() {
    return _dumpers;
  }

  // Add a new dumper
  void addDumper(Dumper newDumper) {
    _dumpers.add(newDumper);
  }

  // Delete a dumper
  void deleteDumper(Dumper dumper) {
    _dumpers.removeWhere((d) => d.id == dumper.id);
  }

  // Update an existing dumper
  void updateDumper(Dumper updatedDumper) {
    int index = _dumpers.indexWhere((d) => d.id == updatedDumper.id);
    if (index != -1) {
      _dumpers[index] = updatedDumper;
    }
  }
}
