// // import 'package:bluetooth_attendance/pages/bluetooth.dart';
// import 'package:bluetooth_attendance/components/global_var.dart';
// import 'package:bluetooth_attendance/components/student_page_comp.dart';
// import 'package:bluetooth_attendance/pages/common.dart';
// import 'package:flutter/material.dart';

// class TeacherAttBluePage extends StatelessWidget {
//   final String dropdownvalue = 'Select the class';
//   const TeacherAttBluePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const appbarWidget(iconD: "teacher"),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           TextButton(
//             style: ButtonStyle(
//               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               backgroundColor: const WidgetStatePropertyAll(
//                 Color.fromRGBO(217, 217, 217, 1),
//               ),
//             ),
//             onPressed: () {
//               checkBluetooth(context); //check blu on or off
//             },
//             child: const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 "Scan",
//                 style: TextStyle(fontSize: 20, color: Colors.black),
//               ),
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
//             child: SizedBox(
//               child: Column(
//                 children: [
//                   Container(
//                     height: 30,
//                     width: double.infinity,
//                     clipBehavior: Clip.hardEdge,
//                     decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10))),
//                     child: const ColoredBox(
//                       color: Color.fromRGBO(188, 185, 185, 1),
//                       child: Text(
//                         "  Bluetooth",
//                         style: TextStyle(fontSize: 22),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 350,
//                     width: double.infinity,
//                     clipBehavior: Clip.hardEdge,
//                     decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(10),
//                             bottomRight: Radius.circular(10))),
//                     child: const ColoredBox(
//                       color: Color.fromRGBO(217, 217, 217, 1),
//                       // child:
//                       // ScanScreen(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Dropdown(
//                         dropdownItems: classList,
//                         hint: "Class",
//                       ),
//                       Dropdown(
//                         dropdownItems: classDIV,
//                         hint: "Div",
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Button(buttonText: "Submit", onPressed: () {}),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const Divider(
//                     color: Color.fromRGBO(217, 217, 217, 1),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Button(buttonText: "Add ID", onPressed: () {}),
//                       Button(buttonText: "Report", onPressed: () {}),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Button extends StatelessWidget {
//   final String buttonText; // Text to display on the button
//   final VoidCallback onPressed; // Function to call when button is pressed

//   const Button({
//     super.key,
//     required this.buttonText, // Required parameter for button text
//     required this.onPressed, // Required parameter for the onPressed function
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150,
//       clipBehavior: Clip.hardEdge,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(8),
//         ),
//       ),
//       child: ColoredBox(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         child: TextButton(
//           onPressed:
//               onPressed, // Call the passed function when button is pressed
//           child: Text(
//             buttonText, // Display the passed text
//             style: const TextStyle(
//               fontSize: 25,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
