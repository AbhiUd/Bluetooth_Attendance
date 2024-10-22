import 'package:bluetooth_attendance/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudentSubjectDetail extends StatefulWidget {
  const StudentSubjectDetail({super.key});

  @override
  State<StudentSubjectDetail> createState() => _StudentSubjectDetailState();
}

class _StudentSubjectDetailState extends State<StudentSubjectDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(iconD: "student"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 45,
              decoration: BoxDecoration(
                color: Color.fromRGBO(188, 185, 185, 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Text(
                  "Attendance detail",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded( 
              child: ListView.builder(
                itemCount: subjectData.length, 
                itemBuilder: (context, index) {
                  return subjectCard(
                    subjectData[index]['name'],
                    subjectData[index]['attendance'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> subjectData = [
  {"name": "Software Engineering", "attendance": 85.0},
  {"name": "Theory of Computation Science", "attendance": 7.5},
  {"name": "Chemistry", "attendance": 78.3},
];


Widget subjectCard(String subjectName, double attendancePercentage) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 5,
    margin: EdgeInsets.all(10),
    child: SizedBox(
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                subjectName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CircularPercentIndicator(
              radius: 35.0,
              lineWidth: 8.0,
              percent: attendancePercentage / 100,
              center: Text(
                "${attendancePercentage.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: attendancePercentage >= 75
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              progressColor: attendancePercentage >= 75
                  ? Colors.green
                  : Colors.red,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        ],
      ),
    ),
  );
}
