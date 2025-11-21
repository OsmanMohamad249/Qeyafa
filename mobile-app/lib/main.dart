// mobile-app/lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'features/measurement/screens/smart_camera_screen.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const QeyafaApp());
  }, (error, stack) {
    print('Caught Dart Error: $error');
    print(stack);
  });
}

class QeyafaApp extends StatelessWidget {
  const QeyafaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qeyafa - AI Measurement',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SmartCameraScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
