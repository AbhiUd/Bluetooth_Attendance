import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});
  @override
  State<StudentPage> createState() => _StudentPageState();
}
 const IconData person = IconData(0xee35, fontFamily: 'MaterialIcons');

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(92, 89, 145, 87),
        elevation: 0,
        toolbarHeight: 90, 

        // Making the image clickable using GestureDetector
        leading:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: 
        IconButton(
          icon: const Icon(
            person, 
            size: 60, 
            color: Colors.white, 
          ),
          onPressed: () {
            print('Person icon pressed');
          },
        ) ,
        ),  
        title: Image.asset("assets/images/student.png",height: 80,
         width: 80,
          color: Colors.white),
        centerTitle: true,
        
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: 
          IconButton(
              icon: const Icon(Icons.notification_add_outlined, size: 50, color: Colors.white,),
                onPressed: () {
                     print("notification is pressed");
                  },
            ),
          )
        ],
      ),
      body: 
      SizedBox(
        width: double.maxFinite,
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(217, 217, 217, 1), // Set background color
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
                  ),
    
                ),
        child: const Text('Attendance ', style: TextStyle(fontSize: 30),),
)
          ],
        ),
      )
    );
  }
}