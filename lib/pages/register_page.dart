import 'package:bluetooth_attendance/components/login_page_component.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailTextContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Align(
                  child: Image.asset('assets/images/login_page_logo.png'),
                ),
                SizedBox(
                  height: 0.09 * size.height,
                ),
                Text(
                  "Welcome!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Please enter your email",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 40,
                ),
                EmailTextField(
                  text: "Email",
                  emailTextContoller: emailTextContoller,
                  icon: const Icon(Icons.person),
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleFieldSubmitButton(
                  emailTextContoller: emailTextContoller,
                  onTap: () async {
                    if (emailTextContoller.text.isNotEmpty) {
                      final response = await Supabase.instance.client
                          .from('predefined_details')
                          .select()
                          .eq('registered_status', false)
                          .eq('emailid', emailTextContoller.text);
                      print("IN Checking for predefined details");
                      print(emailTextContoller.text);
                      print(response);

                      if (context.mounted) {
                        if (response.isNotEmpty) {
                          print("Emial id found");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage2(
                                emailId: emailTextContoller.text,
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Enter your correct Email Id',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Email id already has an account',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "SignIn",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(21, 18, 55, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage2 extends StatefulWidget {
  final dynamic emailId;

  const RegisterPage2({
    super.key,
    this.emailId,
  });

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController newPassTextContoller = TextEditingController();
  final TextEditingController confirmPassTextContoller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Align(
                  child: Image.asset('assets/images/login_page_logo.png'),
                ),
                SizedBox(
                  height: 0.09 * size.height,
                ),
                EmailTextField(
                  text: "New Password",
                  emailTextContoller: newPassTextContoller,
                  icon: const Icon(Icons.fingerprint),
                ),
                const SizedBox(
                  height: 20,
                ),
                EmailTextField(
                  text: "Confirm Password",
                  emailTextContoller: confirmPassTextContoller,
                  icon: const Icon(Icons.fingerprint),
                ),
                const SizedBox(
                  height: 30,
                ),
                SubmitButton(
                  text: "Register",
                  emailTextContoller: newPassTextContoller,
                  passwordTextContoller: confirmPassTextContoller,
                  onTap: () async {
                    if ((newPassTextContoller.text.isNotEmpty &&
                            confirmPassTextContoller.text.isNotEmpty) &&
                        (newPassTextContoller.text ==
                            confirmPassTextContoller.text)) {
                      final uuid = generateUUID();
                      final studentDetail = await Supabase.instance.client
                          .from("predefined_details")
                          .select()
                          .eq("emailid", widget.emailId);

                      final response = await Supabase.instance.client
                          .from('student_details')
                          .insert({
                        'emailid': widget.emailId,
                        'password': newPassTextContoller.text,
                        'uuid': uuid,
                        'prn': studentDetail[0]["prn"],
                        'class': studentDetail[0]["class"],
                        'division': studentDetail[0]["division"],
                        'name': studentDetail[0]['name'],
                      });
                      print(response);
                      await saveUUID(uuid);

                      final update = await Supabase.instance.client
                          .from("predefined_details")
                          .update({"registered_status": true}).match(
                              {"emailid": widget.emailId});
                      await FirebaseMessaging.instance.requestPermission();
                      await FirebaseMessaging.instance.getAPNSToken();
                      final fcmtoken =
                          await FirebaseMessaging.instance.getToken();
                      if (fcmtoken != null) {
                        await _setfcmtoken(fcmtoken, studentDetail[0]["prn"]);
                      }
                      FirebaseMessaging.instance.onTokenRefresh
                          .listen((fcmtoken) async {
                        await _setfcmtoken(fcmtoken, studentDetail[0]["prn"]);
                      });
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/rolespage',
                          (Route<dynamic> route) => false,
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Please Correct Password',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setfcmtoken(String fcmtoken, String studentPRN) async {
    try {
      final insertResponse = await Supabase.instance.client
          .from('firebase_token')
          .insert({'prn': studentPRN, 'token': fcmtoken});
    } catch (e) {
      print(e);
    }
  }
}
