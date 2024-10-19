// import 'package:bluetooth_attendance/components/login_page_component.dart';
// import 'package:bluetooth_attendance/components/student_page_comp.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

// class StudentPage extends StatefulWidget {
//   const StudentPage({super.key});
//   @override
//   State<StudentPage> createState() => _StudentPageState();
// }

// class _StudentPageState extends State<StudentPage> {
//   final UUID = getUUID();

//   final FlutterBlePeripheral _blePeripheral = FlutterBlePeripheral();
//   bool _isAdvertising = false;
//   bool _isSupported = false;
//   final String studentUUID =
//       'bf27730d-860a-4e09-889c-2d8b6a9e0fe7'; // Unique for each student

//   @override
//   void initState() {
//     super.initState();
//     _checkSupport();
//   }

//   // Check if BLE advertising is supported on the device
//   Future<void> _checkSupport() async {
//     bool supported = await _blePeripheral.isSupported;
//     setState(() {
//       _isSupported = supported;
//     });
//   }

//   // Start or stop advertising UUID
//   Future<void> _toggleAdvertising() async {
//     if (_isAdvertising) {
//       await _blePeripheral.stop();
//     } else {
//       print("Entered Advertising State");
//       AdvertiseData advertiseData = AdvertiseData(
//         serviceUuid: studentUUID, // UUID identifying the student
//         localName:
//             "Student_${studentUUID.substring(0, 5)}", // Can be student's name or part of UUID
//         manufacturerId: 1234,
//         // manufacturerData: Uint8List.fromList([1, 2, 3, 4]), // Optional additional data
//       );

//       await _blePeripheral.start(advertiseData: advertiseData);
//     }

//     setState(() {
//       _isAdvertising = !_isAdvertising;
//     });
//   }

//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   if (state == AppLifecycleState.resumed) {
//   //     startBroadcast();
//   //   } else if (state == AppLifecycleState.paused) {
//   //     stopBeaconBroadcast();
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     const IconData person = IconData(0xee35, fontFamily: 'MaterialIcons');
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(92, 89, 145, 87),
//         elevation: 0,
//         toolbarHeight: 90,

//         // Making the image clickable using GestureDetector
//         leading: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: IconButton(
//             icon: const Icon(
//               person,
//               size: 60,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               print('Person icon pressed');
//             },
//           ),
//         ),
//         title: Image.asset("assets/images/student.png",
//             height: 80, width: 80, color: Colors.white),
//         centerTitle: true,

//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.notification_add_outlined,
//                 size: 50,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 print("notification is pressed");
//               },
//             ),
//           )
//         ],
//       ),
//       body: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 100),
//             ElevatedButton(
//               onPressed: () {
//                 checkBluetooth(context);
//                 _toggleAdvertising;
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromRGBO(
//                     217, 217, 217, 1), // Set background color
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Attendance ',
//                 style: TextStyle(fontSize: 30),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:bluetooth_attendance/components/login_page_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // Import to check Bluetooth state
import 'package:permission_handler/permission_handler.dart'; // For permission checks

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
  // Unique for each student

  @override
  void initState() {
    super.initState();
    _checkSupport();
    _checkBluetooth(); // Check Bluetooth status on init
  }

  // Check if BLE advertising is supported on the device
  Future<void> _checkSupport() async {
    studentUUID = (await getUUID())!;
    bool supported = await _blePeripheral.isSupported;
    setState(() {
      _isSupported = supported;
    });
  }

  // Check Bluetooth state
  Future<void> _checkBluetooth() async {
    PermissionStatus bluetoothScanStatus =
        await Permission.bluetoothScan.request();
    PermissionStatus bluetoothConnectStatus =
        await Permission.bluetoothConnect.request();

    if (bluetoothScanStatus.isGranted && bluetoothConnectStatus.isGranted) {
      _listenToBluetoothState();
    } else {
      _showBluetoothPermissionDenied();
    }
  }

  // Listen to Bluetooth adapter state
  void _listenToBluetoothState() {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _bluetoothEnabled = state == BluetoothAdapterState.on;
      });
    });
  }

  // Show alert if Bluetooth permissions are denied
  void _showBluetoothPermissionDenied() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Bluetooth Permission Denied"),
        content:
            Text("Please enable Bluetooth permissions in the app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // Start or stop advertising UUID
  Future<void> _toggleAdvertising() async {
    if (_isAdvertising) {
      await _blePeripheral.stop();
      print("Advertising stopped.");
    } else {
      print("Entered Advertising State");
      AdvertiseData advertiseData = AdvertiseData(
        serviceUuid: studentUUID, // UUID identifying the student
        localName:
            "Student_${studentUUID.substring(0, 8)}", // Can be student's name or part of UUID
        manufacturerId: 1234,
        // manufacturerData: Uint8List.fromList([1, 2, 3, 4]), // Optional additional data
      );

      await _blePeripheral.start(advertiseData: advertiseData);
      final localName = advertiseData.localName;
      print("Advertising started. \n $localName");
    }

    setState(() {
      _isAdvertising = !_isAdvertising;
    });
  }

  @override
  Widget build(BuildContext context) {
    const IconData person = IconData(0xee35, fontFamily: 'MaterialIcons');

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(92, 89, 145, 87),
        elevation: 0,
        toolbarHeight: 90,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            icon: const Icon(
              person,
              size: 60,
              color: Colors.white,
            ),
            onPressed: () {
              print('Person icon pressed');
            },
          ),
        ),
        title: Image.asset("assets/images/student.png",
            height: 80, width: 80, color: Colors.white),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(
                Icons.notification_add_outlined,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () {
                print("Notification is pressed");
              },
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                if (_bluetoothEnabled && _isSupported) {
                  _toggleAdvertising();
                } else {
                  _showBluetoothDisabledAlert();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(
                    217, 217, 217, 1), // Set background color
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Attendance ',
                style: TextStyle(fontSize: 30),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Show alert when Bluetooth is disabled
  void _showBluetoothDisabledAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Bluetooth Disabled"),
        content: Text("Please enable Bluetooth to start attendance."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
