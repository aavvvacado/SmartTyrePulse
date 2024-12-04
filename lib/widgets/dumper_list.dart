import 'package:flutter/material.dart';

import '../repositories/dumper_repository.dart';

class DumperList extends StatelessWidget {
  final dumperRepository = DumperRepository();

  @override
  Widget build(BuildContext context) {
    final dumpers = dumperRepository.getDumpers();

    return ListView.builder(
      itemCount: dumpers.length,
      itemBuilder: (context, index) {
        final dumper = dumpers[index];
        return ListTile(
          title: Text(dumper.name, style: TextStyle(color: Colors.white)),
          subtitle: Text(
              'Location: ${dumper.location}, Operator: ${dumper.operator}',
              style: TextStyle(color: Colors.grey)),
          trailing: Text(dumper.status, style: TextStyle(color: Colors.orange)),
        );
      },
    );
  }
}
