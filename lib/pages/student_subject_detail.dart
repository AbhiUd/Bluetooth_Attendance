import 'package:bluetooth_attendance/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentSubjectDetail extends StatefulWidget {
  const StudentSubjectDetail({super.key});

  @override
  State<StudentSubjectDetail> createState() => _StudentSubjectDetailState();
}

class _StudentSubjectDetailState extends State<StudentSubjectDetail> {
  bool _isLoading = true; 

  List<String> subjectCodes = ['501', '502', '503'];
  List<int> totalClasses = [];
  List<int> studentPresent = [];
  List<Map<String, dynamic>> subjectData = [
    {"name": "Software Engineering", "attendance": 0.0},
    {"name": "Theoretical Computer Science", "attendance": 0.0},
    {"name": "Deta Warehouse and Mining", "attendance": 0.0},
  ];

  @override
  void initState() {
    super.initState();
    fetchAttendanceCount(subjectCodes);
  }
  

  
  Future<void> fetchSubjectCodesAndNames() async {
  setState(() {
    _isLoading = true; // Start loading
  });

  try {
    final supabase = Supabase.instance.client;

    // Debugging: Print Student_year and Student_division values
    print('Student_year: $Student_year, Student_division: $Student_division');

    if (Student_year == null || Student_division == null || Student_year!.isEmpty || Student_division!.isEmpty) {
      print('Error: Student_year or Student_division is null or empty');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final response = await supabase
        .from('subject_detail')
        .select('subject_code, subject_name')
        .eq('subject_year', Student_year ?? '')
        .eq('division', Student_division ?? '');

    print('Supabase response: ${response.data}');
    print('Supabase error: ${response.error?.message}');

    if (response.error == null && response.data != null && response.data.isNotEmpty) {
      List<Map<String, String>> fetchedSubjectData = List<Map<String, String>>.from(
        response.data.map((item) => {
          'subject_code': item['subject_code'],
          'subject_name': item['subject_name'],
        }),
      );

      setState(() {
        subjectData = fetchedSubjectData
            .map((subject) => {
                  "name": subject['subject_name'] ?? '',
                  "code": subject['subject_code'] ?? '',
                  "attendance": 0.0,
                })
            .toList();
        _isLoading = false; // Stop loading when data is fetched
      });
    } else {
      setState(() {
        _isLoading = false; // Stop loading if no data or error occurs
      });
      print('No data found or error fetching subject data: ${response.error?.message ?? "No data"}');
    }
  } catch (e) {
    setState(() {
      _isLoading = false; // Stop loading if an exception occurs
    });
    print('Error: $e');
  }
}




  






  Future<void> fetchAttendanceCount(List<String> subjectCodes) async {
    final supabase = Supabase.instance.client;

    for (int i = 0; i < subjectCodes.length; i++) {
      final subjectCode = subjectCodes[i];

      final totalClassesResponse = await supabase
          .from('student_attendance')
          .select()
          .eq('subject_code', subjectCode);

      if (totalClassesResponse.error == null) {
        totalClasses.add(totalClassesResponse.length);
      } else {
        totalClasses.add(0);
      }

      final studentPresentResponse = await supabase
          .from('student_attendance')
          .select()
          .eq('subject_code', subjectCode)
          .eq('prn', StudentPRN ?? '')
          .eq('attendance_status', true);

      if (studentPresentResponse.error == null) {
        studentPresent.add(studentPresentResponse.length);
      } else {
        studentPresent.add(0);
      }

      if (totalClasses[i] != 0) {
        double attendancePercentage = (studentPresent[i] / totalClasses[i]) * 100.0;
        setState(() {
          subjectData[i]['attendance'] = attendancePercentage;
        });
      } else {
        setState(() {
          subjectData[i]['attendance'] = 0.0;
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(iconD: "teacher"),
      body: _isLoading ? _buildLoader() : build2(context),
    );
  }

  Widget _buildLoader() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              "Attendance detail",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, color: Colors.white),
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
    );
  }
}

extension on PostgrestList {
  get error => null;
  get data => null;
}

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
