// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TeacherScanPage extends StatefulWidget {
  const TeacherScanPage({Key? key}) : super(key: key);

  @override
  _TeacherScanPageState createState() => _TeacherScanPageState();
}

class _TeacherScanPageState extends State<TeacherScanPage> {
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  // Method to start scanning
  void _scanForDevices() async {
    setState(() {
      isScanning = true;
    });

    // Start scanning for nearby devices
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 15));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });

      for (var result in results) {
        // Fallback for devices without a localName

        String deviceName = result.advertisementData.localName.isNotEmpty
            ? result.advertisementData.localName
            : result.device.remoteId
                .toString(); // Use remoteId if localName is empty

        print('${result.device.remoteId}: "$deviceName" found!');
      }
    });

    // Stop scanning when timeout is reached
    await FlutterBluePlus.isScanning
        .where((scanning) => scanning == false)
        .first;

    setState(() {
      isScanning = false;
    });
  }

  // Stop scanning manually
  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Scanner"),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.refresh),
            onPressed: isScanning ? _stopScan : _scanForDevices,
          ),
        ],
      ),
      body: Column(
        children: [
          if (scanResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final result = scanResults[index];

                  // Handle advertisement data
                  final localName =
                      result.advertisementData.localName.isNotEmpty
                          ? result.advertisementData.localName
                          : "Unnamed device";
                  final advName = result.advertisementData.advName;
                  final serviceUuids =
                      result.advertisementData.serviceUuids.isNotEmpty
                          ? result.advertisementData.serviceUuids
                              .join(", ") // Convert to comma-separated string
                          : "No service UUIDs";

                  return ListTile(
                    title: Text(result.device.remoteId.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Local Name: $localName"),
                        Text("Adv Name: $advName"),
                        Text("Service UUIDs: $serviceUuids"),
                      ],
                    ),
                  );
                }, //
              ),
            )
          else if (!isScanning)
            const Center(child: Text("No devices found.")),
        ],
      ),
    );
  }
}
