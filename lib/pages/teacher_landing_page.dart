import 'package:bluetooth_attendance/components/student_page_comp.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:bluetooth_attendance/pages/teacher_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Teacher_Landing_Page extends StatelessWidget {
  const Teacher_Landing_Page({super.key});

  Future<void> _checkBluetooth(BuildContext context) async {
    // Request Bluetooth permissions
    PermissionStatus bluetoothScanStatus =
        await Permission.bluetoothScan.request();
    PermissionStatus bluetoothConnectStatus =
        await Permission.bluetoothConnect.request();

    if (bluetoothScanStatus.isGranted && bluetoothConnectStatus.isGranted) {
      // If permissions are granted, listen to Bluetooth state
      FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        if (state == BluetoothAdapterState.on) {
          // If Bluetooth is enabled, navigate to attendance page
          Navigator.of(context).pushNamed("/attendancepage");
        } else {
          // Show dialog to enable Bluetooth if it's off
          _showBluetoothDialog(context);
        }
      });
    } else {
      _showBluetoothPermissionDenied(context);
    }
  }

  // Show alert if Bluetooth permissions are denied
  void _showBluetoothPermissionDenied(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bluetooth Permission Denied"),
        content: const Text(
            "Please enable Bluetooth permissions in the app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Show alert to enable Bluetooth
  void _showBluetoothDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bluetooth is Disabled"),
        content: const Text("Please enable Bluetooth to take attendance."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally open settings to enable Bluetooth
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appbarWidget(iconD: "teacher"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () async {
                  checkBluetooth(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const TeacherAttendance(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Take Attendance ',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Report',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
