import 'package:bluetooth_attendance/components/global_var.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:bluetooth_attendance/pages/scanning_page.dart';
import 'package:flutter/material.dart';

class AbsenteePage extends StatefulWidget {
  const AbsenteePage({super.key});

  @override
  State<AbsenteePage> createState() => _AbsenteePageState();
}

class _AbsenteePageState extends State<AbsenteePage> {
  void _markAsPresent(String prn) {
    setState(() {
      absenteeList.remove(prn);
      scannedList.add(prn);
    });
  }

  Future<void> _showConfirmationDialog(String prn) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text('Do you want to mark PRN: $prn as present?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _markAsPresent(prn);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: appbarWidget(iconD: "teacher"),
        body: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Absentees PRN',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: absenteeList.isEmpty
                  ? const Center(
                      child: Text(
                        'No Absentees',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: absenteeList.length,
                      itemBuilder: (context, index) {
                        final prn = absenteeList[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: Text(
                              'PRN: $prn',
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              onPressed: () {
                                _showConfirmationDialog(prn);
                              },
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
                          const ScanningPage(), // Replace 'NextPage' with your destination widget
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
                  "Go back",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
