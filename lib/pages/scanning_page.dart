import 'package:bluetooth_attendance/components/global_var.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:flutter/material.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(iconD: "teacher"),
      body: SizedBox(
        width: double.infinity,
        child: Column(
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
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
