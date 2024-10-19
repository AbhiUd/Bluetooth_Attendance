import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SubmitButton extends StatelessWidget {
  final Function()? onTap;

  const SubmitButton({
    super.key,
    required this.emailTextContoller,
    required this.passwordTextContoller,
    required this.onTap,
  });

  final TextEditingController emailTextContoller;
  final TextEditingController passwordTextContoller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(86, 183, 221, 1),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.emailTextContoller,
    required this.icon,
    required this.text,
  });

  final TextEditingController emailTextContoller;
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    const blackColor = TextStyle(
      color: Colors.black87,
    );
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.5,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    );
    return TextField(
      controller: emailTextContoller,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: blackColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color.fromRGBO(217, 217, 217, 1),
        prefixIcon: icon,
        prefixIconColor: Colors.black87,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class SingleFieldSubmitButton extends StatelessWidget {
  final Function()? onTap;

  const SingleFieldSubmitButton({
    super.key,
    required this.emailTextContoller,
    required this.onTap,
  });

  final TextEditingController emailTextContoller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(86, 183, 221, 1),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        "Submit",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}

Future<String?> getDeviceIdentifier() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
  final allInfo = deviceInfo.id;
  return allInfo.toString();
}

String generateUUID() {
  final String studentUUID = Uuid().v4();
  return studentUUID;
}

Future<void> saveUUID(String uuid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('studentUUIDD', uuid);
}

Future<String?> getUUID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? action = prefs.getString('studentUUIDD');
  return action;
}
