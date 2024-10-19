import 'package:bluetooth_attendance/pages/blank_page.dart';
import 'package:bluetooth_attendance/pages/login_page.dart';
import 'package:bluetooth_attendance/pages/register_page.dart';
import 'package:bluetooth_attendance/pages/role.dart';
import 'package:bluetooth_attendance/pages/scanning_page.dart';
import 'package:bluetooth_attendance/pages/student_page.dart';
import 'package:bluetooth_attendance/pages/teacher_attendance.dart';
import 'package:bluetooth_attendance/pages/teacher_landing_page.dart';
import 'package:bluetooth_attendance/pages/teacher_login_page.dart';
import 'package:bluetooth_attendance/pages/teacher_register_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yibgavrmokwdadpygfdq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpYmdhdnJtb2t3ZGFkcHlnZmRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1OTQyMzUsImV4cCI6MjA0MzE3MDIzNX0.P8WXRoU1i3xf76Y3cFq9d-7Vh7dUHLzagKdp4I3o0v0',
  );

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
          seedColor: const Color.fromRGBO(21, 18, 55, 1),
        ),
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
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(92, 89, 145, 87),
      ),
      themeMode: ThemeMode.dark,
      home: const RolesPage(),
      routes: <String, WidgetBuilder>{
        '/rolespage': (BuildContext context) => const RolesPage(),
        '/loginpage': (BuildContext context) => const LoginPage(),
        '/teacherloginpage': (BuildContext context) => const TeacherLoginPage(),
        '/test': (BuildContext context) => const TestingPage(),
        '/registerpage': (BuildContext context) => const RegisterPage(),
        '/teacherregisterpage': (BuildContext context) =>
            const TeacherRegisterPage(),
        '/studentpage': (BuildContext context) => const StudentPage(),
        '/teacherpage': (BuildContext context) => const Teacher_Landing_Page(),
        '/attendancepage': (BuildContext context) => const TeacherAttendance(),
        '/scanningpage': (BuildContext context) => const ScanningPage(),
        '/registerpage2': (BuildContext context) => const RegisterPage2(),
      },
    );
  }
}
