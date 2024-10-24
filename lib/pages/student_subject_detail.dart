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

  List<int> totalClasses = [];
  List<int> studentPresent = [];
  List<Map<String, dynamic>> subjectData = [];

  @override
  void initState() {
    super.initState();
    fetchSubjectCodesAndNames();
  }

  Future<void> fetchSubjectCodesAndNames() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final supabase = Supabase.instance.client;

      if (Student_year!.isEmpty || Student_division!.isEmpty) {
        print('Error: Student_year or Student_division is null or empty');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await supabase
          .from('subject_detail')
          .select('subject_code, subject_name')
          .eq('subject_year', Student_year!)
          .eq('division', Student_division!);

      print('Supabase response: $response');
      print('Supabase error: $response');

      if (response.isNotEmpty) {
        print("Entered Fetchdata Mapping");
        Iterable<Map<String, dynamic>> fetchedSubjectData =
            response.map((item) => {
                  'subject_code': item['subject_code'],
                  'subject_name': item['subject_name'],
                });

        setState(() {
          subjectData = fetchedSubjectData
              .map((subject) => {
                    "name": subject['subject_name'],
                    "code": subject['subject_code'],
                    "attendance": 0.0,
                  })
              .toList();
        });
        print("Converted SubjectData: $subjectData ");
        fetchAttendanceCount();
      } else {
        setState(() {
          _isLoading = false; // Stop loading if no data or error occurs
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading if an exception occurs
      });
      print('Error: $e');
    }
  }

  Future<void> fetchAttendanceCount() async {
    try {
      final supabase = Supabase.instance.client;
      totalClasses.clear();
      studentPresent.clear();

      for (int i = 0; i < subjectData.length; i++) {
        final subjectCode = subjectData[i]["code"];
        final totalClassesResponse = await supabase
            .from('student_attendance')
            .select()
            .eq('subject_code', subjectCode)
            .eq('prn', StudentPRN!);

        if (totalClassesResponse.isNotEmpty) {
          totalClasses.add(totalClassesResponse.length);
        } else {
          totalClasses.add(0);
        }

        final studentPresentResponse = await supabase
            .from('student_attendance')
            .select()
            .eq('subject_code', subjectCode)
            .eq('prn', StudentPRN!)
            .eq('attendance_status', true);

        if (studentPresentResponse.isNotEmpty) {
          studentPresent.add(studentPresentResponse.length);
        } else {
          studentPresent.add(0);
        }

        // Calculate attendance percentage
        if (totalClasses[i] != 0) {
          double attendancePercentage =
              (studentPresent[i] / totalClasses[i]) * 100.0;

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
    } catch (e) {
      print("Error: $e");
    }
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
                return SubjectCard(
                  subjectName: subjectData[index]['name'],
                  attendancePercentage: subjectData[index]['attendance'],
                  presentDays: studentPresent[index],
                  totalLectures: totalClasses[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class SubjectCard extends StatefulWidget {
  final String subjectName;
  final double attendancePercentage;
  final int presentDays;
  final int totalLectures;

  const SubjectCard({
    Key? key,
    required this.subjectName,
    required this.attendancePercentage,
    required this.presentDays,
    required this.totalLectures,
  }) : super(key: key);

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool _isExpanded = false; // Track card expansion state

  void _toggleCard() {
    setState(() {
      _isExpanded = !_isExpanded; // Toggle the expansion state
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // Remove the fixed height to allow dynamic sizing
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Dynamically adjust height based on content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display subject name and attendance percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.subjectName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                CircularPercentIndicator(
                  radius: 35.0,
                  lineWidth: 8.0,
                  percent: widget.attendancePercentage / 100,
                  center: Text(
                    "${widget.attendancePercentage.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: widget.attendancePercentage >= 75
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  progressColor: widget.attendancePercentage >= 75
                      ? Colors.green
                      : Colors.red,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
            // Conditionally display additional information
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "Present: ${widget.presentDays} / Total: ${widget.totalLectures}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}