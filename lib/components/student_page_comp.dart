import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// Check Bluetooth function
Future<void> checkBluetooth(BuildContext context) async {
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
        // Listen to adapter state changes
        _listenToBluetoothState(context);
      } else if (bluetoothScanStatus.isDenied ||
          bluetoothConnectStatus.isDenied) {
        _showSnackBar(
            context, 'Bluetooth Permission is mandatory for attendance');
      } else if (bluetoothScanStatus.isPermanentlyDenied ||
          bluetoothConnectStatus.isPermanentlyDenied) {
        openAppSettings(); // Direct user to app settings
      }
    } else {
      // If not Android, directly listen to Bluetooth state
      _listenToBluetoothState(context);
    }
  } catch (e) {
    print(e);
  }
}

// Show SnackBar helper function
void _showSnackBar(BuildContext context, String message) {
  var snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Listen to Bluetooth adapter state
void _listenToBluetoothState(BuildContext context) {
  StreamSubscription<BluetoothAdapterState>? subscription;

  subscription =
      FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
    print(state);
    if (state == BluetoothAdapterState.on) {
      return;
    } else if (state == BluetoothAdapterState.off) {
      _showBluetoothAlert(context, subscription);
    }
  });
}

// Show Bluetooth alert dialog
void _showBluetoothAlert(BuildContext context,
    StreamSubscription<BluetoothAdapterState>? subscription) {
  if (context.mounted) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Bluetooth ALERT",
      desc: "Turn On Your Device Bluetooth",
      buttons: [
        DialogButton(
          border: Border.all(color: Colors.black, width: 2),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            subscription?.cancel();
          },
          color: const Color.fromARGB(112, 253, 135, 111),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
          ),
        ),
        DialogButton(
          border: Border.all(color: Colors.black, width: 2),
          onPressed: () async {
            try {
              // Attempt to turn on Bluetooth
              if (Platform.isAndroid) {
                await FlutterBluePlus.turnOn();
                print("Bluetooth turned ON.");
              }
            } catch (e) {
              if (e is FlutterBluePlusException) {
                print('Failed to turn on Bluetooth: $e');
                _showSnackBar(
                    context, 'Please enable Bluetooth manually in settings.');
              } else {
                _showSnackBar(context, 'An unexpected error occurred.');
              }
            }

            Navigator.pop(context);
            subscription?.cancel();
          },
          color: const Color.fromARGB(156, 140, 255, 111),
          child: const Text(
            "OK",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
          ),
        ),
      ],
      style: const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
    ).show();
  }
}
