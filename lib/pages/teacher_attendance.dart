// import 'package:bluetooth_attendance/components/global_var.dart';
// import 'package:bluetooth_attendance/pages/common.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TeacherAttendance extends StatefulWidget {
//   const TeacherAttendance({super.key});

//   @override
//   _TeacherAttendanceState createState() => _TeacherAttendanceState();
// }

// class _TeacherAttendanceState extends State<TeacherAttendance> {
//   bool _scanning = false;
//   bool _isLoading = false; // Boolean for managing loader visibility
//   String? selectedClass; // Declare selectedClass
//   String? selectedDiv; // Declare selectedDiv

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appbarWidget(iconD: "teacher"),
//       body: Stack(
//         children: [
//           _buildMainContent(context),
//           if (_isLoading) _buildLoader(),
//         ],
//       ),
//     );
//   }

//   // Function to build main content
//   Widget _buildMainContent(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 SizedBox(
//                   width: 150,
//                   child: Dropdown(
//                     dropdownItems: classList,
//                     hint: "Class",
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 50,
//                 ),
//                 SizedBox(
//                   width: 150,
//                   child: Dropdown(
//                     dropdownItems: classDIV,
//                     hint: "Div",
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 100,
//             ),
//             ElevatedButton(
//               onPressed: _scanning ? null : _startScanning,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(250, 50),
//                 backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: _scanning
//                   ? const Text(
//                       'Scanning...',
//                       style: TextStyle(
//                         fontSize: 24,
//                       ),
//                     )
//                   : const Text(
//                       'Start Scanning',
//                       style: TextStyle(
//                         fontSize: 24,
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Loader widget
//   Widget _buildLoader() {
//     return Container(
//       color: Colors.black.withOpacity(0.5), // Semi-transparent background
//       child: const Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//         ),
//       ),
//     );
//   }

//   // Function to start scanning and compare UUIDs
//   Future<void> _startScanning() async {
//     // Ensure class and division are selected
//     print("StartScanning  $selectedClass    $selectedDiv");
//     if (selectedClass == null || selectedDiv == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select class and division')),
//       );
//       return;
//     }

//     // Show loader and mark scanning as true
//     setState(() {
//       _isLoading = true;
//       _scanning = true;
//     });

//     // Fetch students details based on selected class and division
//     List<Map<String, dynamic>> studentDetails = await _fetchStudentDetails();

//     // Clear any previously scanned data
//     scannedList.clear();

//     // Start scanning for devices
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

//     // Listen to scan results
//     FlutterBluePlus.scanResults.listen((results) {
//       _processScanResults(results, studentDetails);
//     });

//     // After scan completes, update UI
//     FlutterBluePlus.isScanning.listen((scanning) {
//       if (!scanning) {
//         setState(() {
//           _isLoading = false;
//           _scanning = false;
//         });
//         Navigator.of(context).pushNamed("/scanningpage");
//       }
//     });
//   }

//   // Function to process scan results
//   void _processScanResults(
//       List<ScanResult> results, List<Map<String, dynamic>> studentDetails) {
//     for (ScanResult result in results) {
//       String? serviceUUID = (result.advertisementData.serviceUuids.isNotEmpty
//           ? result.advertisementData.serviceUuids[0]
//           : null) as String?;

//       if (serviceUUID != null) {
//         // Compare scanned serviceUUID with student UUIDs
//         for (var student in studentDetails) {
//           if (student['uuid'] == serviceUUID) {
//             // Add PRN to global scanned list if UUID matches
//             if (!scannedList.contains(student['prn'])) {
//               scannedList.add(student['prn']);
//             }
//             break;
//           }
//         }
//       }
//     }
//   }

//   // Function to fetch student details from Supabase
//   Future<List<Map<String, dynamic>>> _fetchStudentDetails() async {
//     final response = await Supabase.instance.client
//         .from("student_details")
//         .select()
//         .eq("class", selectedClass as String)
//         .eq("division", selectedDiv as String);

//     // Cast PostgrestList to List<Map<String, dynamic>>
//     return (response as List).cast<Map<String, dynamic>>();
//   }
// }

import 'dart:async';

import 'package:bluetooth_attendance/components/global_var.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherAttendance extends StatefulWidget {
  const TeacherAttendance({super.key});

  @override
  _TeacherAttendanceState createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {
  bool _scanning = false;
  bool _isLoading = false; // Boolean for managing loader visibility
  String? selectedClass; // Declare selectedClass
  String? selectedDiv; // Declare selectedDiv

  // Subscriptions for scanning and results
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void dispose() {
    // Cancel subscriptions to prevent memory leaks
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(iconD: "teacher"),
      body: Stack(
        children: [
          _buildMainContent(context),
          if (_isLoading) _buildLoader(),
        ],
      ),
    );
  }

  // Function to build main content
  Widget _buildMainContent(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: Dropdown(
                    dropdownItems: classList,
                    hint: "Class",
                    onChanged: (String? newClass) {
                      setState(() {
                        selectedClass = newClass;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 150,
                  child: Dropdown(
                    dropdownItems: classDIV,
                    hint: "Div",
                    onChanged: (String? newDiv) {
                      setState(() {
                        selectedDiv = newDiv;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: _scanning ? null : _startScanning,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _scanning
                  ? const Text(
                      'Scanning...',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  : const Text(
                      'Start Scanning',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Loader widget
  Widget _buildLoader() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent background
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  // Function to start scanning and compare UUIDs
  Future<void> _startScanning() async {
    // Ensure class and division are selected
    if (selectedClass == null || selectedDiv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select class and division')),
      );
      return;
    }

    // Show loader and mark scanning as true
    setState(() {
      _isLoading = true;
      _scanning = true;
    });

    // Fetch students details based on selected class and division
    List<Map<String, dynamic>> studentDetails = await _fetchStudentDetails();

    // Clear any previously scanned data
    scannedList.clear();

    // Start scanning for devices
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Listen to scan results
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _processScanResults(results, studentDetails);
    });

    // Listen for scanning status
    _isScanningSubscription =
        FlutterBluePlus.isScanning.listen((scanning) async {
      if (!scanning) {
        // Wait until all scan results are processed
        await Future.delayed(const Duration(milliseconds: 500)); // Short delay

        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            _isLoading = false;
            _scanning = false;
          });

          // Navigate to the scanning page after processing is completed
          Navigator.of(context).pushNamed("/scanningpage");
        }
      }
    });
  }

  // Function to process scan results
  void _processScanResults(
      List<ScanResult> results, List<Map<String, dynamic>> studentDetails) {
    for (ScanResult result in results) {
      String? serviceUUID = (result.advertisementData.serviceUuids.isNotEmpty
          ? result.advertisementData.serviceUuids[0].toString()
          : null);

      if (serviceUUID != null) {
        // Compare scanned serviceUUID with student UUIDs
        for (var student in studentDetails) {
          if (student['uuid'] == serviceUUID) {
            // Add PRN to global scanned list if UUID matches
            if (!scannedList.contains(student['prn'])) {
              scannedList.add(student['prn']);
            }
            break;
          }
        }
      }
    }
  }

  // Function to fetch student details from Supabase
  Future<List<Map<String, dynamic>>> _fetchStudentDetails() async {
    final response = await Supabase.instance.client
        .from("student_details")
        .select()
        .eq("class", selectedClass!)
        .eq("division", selectedDiv!);

    return (response as List).cast<Map<String, dynamic>>();
  }
}
