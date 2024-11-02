import 'dart:async';
import 'dart:io';

import 'package:bluetooth_attendance/components/login_page_component.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:bluetooth_attendance/pages/student_subject_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // Import to check Bluetooth state
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart'; // For permission checks

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});
  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final FlutterBlePeripheral _blePeripheral = FlutterBlePeripheral();
  bool _isAdvertising = false;
  bool _isSupported = false;
  bool _bluetoothEnabled = false;
  late String studentUUID;
  StreamSubscription<BluetoothAdapterState>? _bluetoothSubscription;

  @override
  void initState() {
    super.initState();
    _checkSupport();
    _checkBluetooth(); // Check Bluetooth status on init
  }

  @override
  void dispose() {
    _bluetoothSubscription?.cancel();
    super.dispose();
  }

  // Check if BLE advertising is supported on the device
  Future<void> _checkSupport() async {
    studentUUID = (await getUUID())!; // Fetch student-specific UUID
    bool supported = await _blePeripheral.isSupported;
    setState(() {
      _isSupported = supported;
    });
  }

  // Check Bluetooth permissions and state
  Future<void> _checkBluetooth() async {
    try {
      // Check if Bluetooth is supported
      if (!(await FlutterBluePlus.isSupported)) {
        _showSnackBar(context, 'Bluetooth not supported by this device');
        return;
      }

      // Request Bluetooth permissions (only for Android)
      if (Platform.isAndroid) {
        PermissionStatus bluetoothScanStatus =
            await Permission.bluetoothScan.request();
        PermissionStatus bluetoothConnectStatus =
            await Permission.bluetoothConnect.request();

        if (bluetoothScanStatus.isGranted && bluetoothConnectStatus.isGranted) {
          _listenToBluetoothState();
        } else if (bluetoothScanStatus.isDenied ||
            bluetoothConnectStatus.isDenied) {
          _showSnackBar(
              context, 'Bluetooth permission is required for attendance');
        } else if (bluetoothScanStatus.isPermanentlyDenied ||
            bluetoothConnectStatus.isPermanentlyDenied) {
          openAppSettings(); // Direct the user to app settings if permission is permanently denied
        }
      } else {
        // For non-Android platforms, directly listen to Bluetooth state
        _listenToBluetoothState();
      }
    } catch (e) {
      print(e);
    }
  }

  // Listen to Bluetooth adapter state
  void _listenToBluetoothState() {
    _bluetoothSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _bluetoothEnabled = (state == BluetoothAdapterState.on);
      });

      if (state == BluetoothAdapterState.off) {
        _showBluetoothAlert();
      }
    });
  }

  // Show alert if Bluetooth is disabled
  void _showBluetoothAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Bluetooth Disabled",
      desc: "Please turn on Bluetooth for attendance.",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            _bluetoothSubscription
                ?.cancel(); // Stop listening when dialog is dismissed
          },
          child: const Text("Cancel"),
        ),
        DialogButton(
          onPressed: () async {
            try {
              // Attempt to turn on Bluetooth (Android only)
              if (Platform.isAndroid) {
                await FlutterBluePlus.turnOn();
              }
            } catch (e) {
              print("Failed to turn on Bluetooth: $e");
              _showSnackBar(
                  context, 'Unable to enable Bluetooth automatically');
            }
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ).show();
  }

  // Show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Toggle Bluetooth Advertising
  Future<void> _toggleAdvertising() async {
    if (_isAdvertising) {
      await _blePeripheral.stop();
      print("Advertising stopped.");
    } else {
      AdvertiseData advertiseData = AdvertiseData(
        serviceUuid: studentUUID,
        localName: "Student_${studentUUID.substring(0, 8)}",
        manufacturerId: 1234,
      );
      await _blePeripheral.start(advertiseData: advertiseData);
      print("Advertising started.");
    }
    setState(() {
      _isAdvertising = !_isAdvertising;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(
        iconD: 'student',
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.broadcast_on_home_outlined,
                color: Colors.black54,
                size: 40.0,
              ),
              onPressed: () {
                if (_bluetoothEnabled && _isSupported) {
                  _toggleAdvertising();
                } else {
                  _showBluetoothAlert();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: Text(
                _isAdvertising ? "Stop Broadcast" : "Start Broadcast",
                style: TextStyle(fontSize: 30),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     if (_bluetoothEnabled && _isSupported) {
            //       _toggleAdvertising();
            //     } else {
            //       _showBluetoothAlert();
            //     }
            //   },
            //   child: Text(_isAdvertising ? "Stop Broadcast" : "Start Broadcast"),
            // ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.school,
                color: Colors.black54,
                size: 30.0,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const StudentSubjectDetail(),
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
              label: const Text(
                'Check Attendence',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
