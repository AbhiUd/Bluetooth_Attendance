// import 'package:bluetooth_attendance/components/global_var.dart';
// import 'package:bluetooth_attendance/pages/common.dart';
// import 'package:flutter/material.dart';

// class ScanningPage extends StatefulWidget {
//   const ScanningPage({super.key});

//   @override
//   State<ScanningPage> createState() => _ScanningPageState();
// }

// class _ScanningPageState extends State<ScanningPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appbarWidget(iconD: "teacher"),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(height: 20),
//           const Text(
//             'Scanned PRNs',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: scannedList.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No devices scanned yet',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: scannedList.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         elevation: 2,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         child: ListTile(
//                           leading: const Icon(Icons.account_circle),
//                           title: Text(
//                             'PRN: ${scannedList[index]}',
//                             style: const TextStyle(fontSize: 18),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           const SizedBox(height: 10),
//           Align(
//             alignment: Alignment.center,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed("/absenteepage");
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(250, 40),
//                 backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 "Check Absentee",
//                 style: TextStyle(
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () {
//               // Submit action here
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(250, 40),
//               backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
//               foregroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "Submit",
//               style: TextStyle(
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }

import 'package:bluetooth_attendance/pages/absentee_page.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bluetooth_attendance/components/global_var.dart'; // where scannedList is defined

class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  // Supabase client initialization
  bool _isLoading = false;

  // Function to store attendance in the database
  Future<void> _submitAttendance() async {
    setState(() {
      _isLoading = true;
    });

    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    print('Scanned List: $scannedList');
    print('Subject Code: $subjectCode');
    print('SelectedClass: $selectedClass');
    print('SelectedDivision: $selectedDiv');
    for (String prn in scannedList) {
      try {
        final response =
            await Supabase.instance.client.from('student_attendance').insert({
          'prn': prn,
          'subject_code': subjectCode, // Replace with the actual subject code
          'date': currentDate,
          'division': selectedDiv!,
          'class': selectedClass!,
          'attendance_status': true, // Mark as present
        });
      } catch (error) {
        // Handle error appropriately
        print("Error inserting attendance for $prn: $error");
      }
    }
    for (String prn in absenteeList) {
      try {
        final response =
            await Supabase.instance.client.from('student_attendance').insert({
          'prn': prn,
          'subject_code': subjectCode,
          'date': currentDate,
          'division': selectedDiv!,
          'class': selectedClass!,
          'attendance_status': false,
        });
      } catch (error) {
        print("Error inserting attendance for $prn: $error");
      }
    }
    setState(() {
      _isLoading = false;
    });
    // Attendance submission complete
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance submitted successfully!')),
    );
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

  Widget _buildMainContent(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      // height: size.height * 0.6,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Scanned PRNs',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: size.height * 0.5,
              child: scannedList.isEmpty
                  ? const Center(
                      child: Text(
                        'No devices scanned yet',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: scannedList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: Text(
                              'PRN: ${scannedList[index]}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AbsenteePage(), // Replace 'NextPage' with your destination widget
                      transitionDuration:
                          Duration.zero, // Removes the animation duration
                      reverseTransitionDuration:
                          Duration.zero, // Removes reverse animation
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Check Absentee",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _submitAttendance();
                subjectCode = "";
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/teacherpage', (Route<dynamic> route) => false);
              }, // Submit action
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 40),
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Submit",
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
}
