import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class appbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String iconD;
  const appbarWidget({super.key, required this.iconD});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(92, 89, 145, 87),
      elevation: 0,
      toolbarHeight: 90,

      // Making the image clickable using GestureDetector
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: IconButton(
          icon: const Icon(
            person,
            size: 60,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      title: Image.asset(
        iconD == "student"
            ? "assets/images/student.png"
            : "assets/images/teacher.png",
        height: 80,
        width: 80,
        color: Colors.white,
      ),
      centerTitle: true,
      actions: [
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: IconButton(
      icon: const Icon(
        Icons.notification_add_outlined,
        size: 50,
        color: Colors.white,
      ),
      onPressed: () {
         Navigator.of(context).pushNamed('/notification');
      },
    ),
  ),
],

    );
  }

  // Implement the preferredSize property
  @override
  Size get preferredSize => const Size.fromHeight(90);
}

const IconData person = IconData(0xee35, fontFamily: 'MaterialIcons');

StreamSubscription<List<ScanResult>>? scanSubscription;

// class _DropdownState extends State<Dropdown> {
//   // Variable to store selected item

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 5, vertical: 5), // Add padding around dropdown
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1), // Background color
//         borderRadius: BorderRadius.circular(10),
//       ), // Rounded corners
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // const SizedBox(width: 10),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 hint: Text(widget.hint),
//                 value: widget.hint == "Class" ? selectedClass : selectedDiv,
//                 icon: const Icon(Icons.arrow_downward), // Dropdown arrow icon
//                 iconSize: 20,
//                 style: const TextStyle(
//                     color: Color.fromARGB(255, 0, 0, 0), fontSize: 25),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     widget.hint == "Class"
//                         ? selectedClass = newValue
//                         : selectedDiv = newValue; // Update selected item
//                   });
//                 },
//                 items: widget.dropdownItems
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                       style: const TextStyle(fontSize: 25),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DropdownState extends State<Dropdown> {
//   String? selectedClass; // Initialize your selected variable
//   String? selectedDiv; // Initialize your selected variable

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 5, vertical: 5), // Add padding around dropdown
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1), // Background color
//         borderRadius: BorderRadius.circular(10),
//       ), // Rounded corners
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 hint: Text(
//                   widget.hint,
//                   style: const TextStyle(
//                     color: Color.fromARGB(
//                         218, 0, 0, 0), // Set hint text color to black
//                     fontSize: 25,
//                   ),
//                 ),
//                 value: widget.hint == "Class" ? selectedClass : selectedDiv,
//                 icon: const Icon(Icons.arrow_downward),
//                 iconEnabledColor: Colors.black, // Dropdown arrow icon
//                 iconSize: 20,
//                 style: const TextStyle(
//                   color: Colors.black, // Set text color to black
//                   fontSize: 25,
//                 ),
//                 dropdownColor: const Color.fromRGBO(
//                     217, 217, 217, 1), // Background color of dropdown
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     if (widget.hint == "Class") {
//                       selectedClass = newValue; // Update selected item
//                     } else {
//                       selectedDiv = newValue; // Update selected item
//                     }
//                   });
//                 },
//                 items: widget.dropdownItems
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                       style: const TextStyle(
//                         color: Colors.black, // Set item text color to black
//                         fontSize: 25,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class Dropdown extends StatefulWidget {
  final List<String> dropdownItems;
  final String hint;
  final ValueChanged<String?> onChanged;

  const Dropdown({
    super.key,
    required this.dropdownItems,
    required this.hint,
    required this.onChanged,
  });

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedValue; // Initialize selected value for dropdown

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 5), // Add padding around dropdown
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 217, 217, 1), // Background color
        borderRadius: BorderRadius.circular(10),
      ), // Rounded corners
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  widget.hint,
                  style: const TextStyle(
                    color: Color.fromARGB(218, 0, 0, 0), // Set hint text color
                    fontSize: 25,
                  ),
                ),
                value: selectedValue,
                icon: const Icon(Icons.arrow_downward),
                iconEnabledColor: Colors.black, // Dropdown arrow icon
                iconSize: 20,
                style: const TextStyle(
                  color: Colors.black, // Set text color to black
                  fontSize: 25,
                ),
                dropdownColor: const Color.fromRGBO(
                    217, 217, 217, 1), // Background color of dropdown
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue; // Update selected item
                  });
                  widget.onChanged(newValue); // Pass value to parent widget
                },
                items: widget.dropdownItems
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black, // Set item text color to black
                        fontSize: 25,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





String? StudentPRN;
String? Student_year;
String? Student_division;



