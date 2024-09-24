import 'package:flutter/material.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.3,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Who Are You?",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/loginpage');
                        },
                        child: Image.asset(
                          'assets/images/student.png',
                        ),
                      ),
                      Text(
                        "Student",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/loginpage');
                        },
                        child: Image.asset(
                          'assets/images/teacher.png',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Teacher",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
