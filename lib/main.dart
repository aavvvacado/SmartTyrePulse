import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tyre_pulse/screens/home_page.dart';
import 'package:smart_tyre_pulse/theme.dart';

import 'blocs/dumper_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DumperBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartTyrePulse',
        theme: appTheme(),
        home: HomePage(),
      ),
    );
  }
}
