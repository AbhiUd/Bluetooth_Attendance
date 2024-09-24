import 'package:bluetooth_attendance/pages/role.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Attendance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(21, 18, 55, 1)),
        useMaterial3: true,
        fontFamily: "Lato",
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(92, 89, 145, 87),
      ),
      themeMode: ThemeMode.dark,
      home: const RolesPage(),
    );
  }
}
