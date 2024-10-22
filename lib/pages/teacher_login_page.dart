import 'package:bluetooth_attendance/components/global_var.dart';
import 'package:bluetooth_attendance/components/login_page_component.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});

  @override
  State<TeacherLoginPage> createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  late bool _isObscure;

  final TextEditingController emailTextContoller = TextEditingController();
  final TextEditingController passwordTextContoller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isObscure = true;
  }

  @override
  void dispose() {
    emailTextContoller.dispose();
    passwordTextContoller.dispose();
    super.dispose();
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
                          setState(
                            () {
                              _isObscure = !_isObscure;
                            },
                          );
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
                        final response = await Supabase.instance.client
                            .from('teacher_details')
                            .select()
                            .eq('emailid', emailTextContoller.text)
                            .eq('password', passwordTextContoller.text);
                        teacherEmail = emailTextContoller.text;
                        if (response.isNotEmpty) {
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/teacherpage',
                              (Route<dynamic> route) => false,
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
                      Navigator.of(context).pushNamed(
                        '/teacherregisterpage',
                      );
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
