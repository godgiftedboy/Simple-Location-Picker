import 'package:flutter/material.dart';
import 'package:simple_location_picker/biometric/biometric_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important!
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BiometricPage(),
    );
  }
}
