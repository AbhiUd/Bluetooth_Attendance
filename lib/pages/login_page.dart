
import 'package:bluetooth_attendance/components/login_page_component.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _isObscure;

  final TextEditingController emailTextContoller = TextEditingController();
  final TextEditingController passwordTextContoller = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _isObscure = true;
    _initializeLocalNotifications(); // Initialize local notifications
    _requestNotificationPermission(); // Request permission to show notifications
    _listenToForegroundMessages(); // Listen to foreground messages
  }

  @override
  void dispose() {
    emailTextContoller.dispose();
    passwordTextContoller.dispose();
    super.dispose();
  }

  // Initialize Local Notifications
  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request notification permission
  void _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Listen for foreground notifications
  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _showNotification(
            message); // Show local notification when in foreground
      }
    });
  }

  // Function to show a local notification
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    const blackColor = TextStyle(
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  Align(
                    child: Image.asset('assets/images/login_page_logo.png'),
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
                    height: 20,
                  ),
                  TextField(
                    controller: passwordTextContoller,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: blackColor,
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      filled: true,
                      fillColor: const Color.fromRGBO(217, 217, 217, 1),
                      prefixIcon: const Icon(Icons.fingerprint),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: _isObscure
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                      suffixIconColor: Colors.black87,
                      prefixIconColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SubmitButton(
                    text: "Login",
                    emailTextContoller: emailTextContoller,
                    passwordTextContoller: passwordTextContoller,
                    onTap: () async {
                      if (emailTextContoller.text.isNotEmpty &&
                          passwordTextContoller.text.isNotEmpty) {
                        final uuid = await getUUID();
                        final response = await Supabase.instance.client
                            .from('student_details')
                            .select()
                            .eq('emailid', emailTextContoller.text)
                            .eq('password', passwordTextContoller.text);

                        if (response.isNotEmpty) {
                          final identifier = response[0]['uuid'];
                          if (identifier == uuid) {
                            StudentPRN = response[0]['prn'];
                            Student_year = response[0]['class'];
                            Student_division = response[0]['division'];
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/studentpage',
                                (Route<dynamic> route) => false,
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'You haven\'t registered in this device',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Please enter a valid email and password',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                                'Please enter a valid email and password',
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
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/registerpage');
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
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
      ),
    );
  }
}
