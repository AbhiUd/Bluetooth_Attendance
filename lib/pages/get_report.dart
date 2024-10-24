import 'package:bluetooth_attendance/components/global_var.dart';
import 'package:bluetooth_attendance/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedClass = null;
    selectedDiv = null;
    subjectCode = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(iconD: "teacher"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Attendance Report",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: Dropdown(
                    dropdownItems: classList,
                    hint: "Class",
                    onChanged: (String? newClass) {
                      setState(() {
                        selectedClass = newClass;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 150,
                  child: Dropdown(
                    dropdownItems: classDIV,
                    hint: "Div",
                    onChanged: (String? newDiv) {
                      setState(() {
                        selectedDiv = newDiv;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll<Size>(Size(275, 50)),
                backgroundColor: WidgetStatePropertyAll<Color>(
                    const Color.fromARGB(255, 219, 205, 219)),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), // Padding
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    side: BorderSide(
                        color: const Color.fromRGBO(217, 217, 217, 1)),
                  ),
                ),
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    startDate = DateTime(picked.year, picked.month, picked.day);
                  });
                }
              },
              child: Text(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                startDate == null
                    ? 'Select Start Date'
                    : 'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate!)}',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll<Size>(Size(275, 50)),
                backgroundColor: WidgetStatePropertyAll<Color>(
                    const Color.fromARGB(255, 219, 205, 219)),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), // Padding
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    side: BorderSide(
                        color: const Color.fromRGBO(217, 217, 217, 1)),
                  ),
                ),
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    endDate = DateTime(picked.year, picked.month, picked.day);
                  });
                }
              },
              child: Text(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                endDate == null
                    ? 'Select End Date'
                    : 'End Date: ${DateFormat('yyyy-MM-dd').format(endDate!)}',
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 50),
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (selectedClass == null || selectedDiv == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select class and division.')),
                  );
                  return;
                }
                final response = await Supabase.instance.client
                    .from("teacher_subject_map")
                    .select()
                    .eq("emailid", teacherEmail!)
                    .eq("class", selectedClass!)
                    .eq("division", selectedDiv!);

                if (response.isNotEmpty) {
                  subjectCode = response[0]["subjectcode"];
                  if (startDate != null && endDate != null) {
                    setState(() {
                      isLoading = true;
                    });
                    await generateAttendanceReport(startDate!, endDate!);
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Please select both start and end dates')),
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'You are not teaching any subject to Class $selectedClass Division $selectedDiv',
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
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Generate Report',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateAttendanceReport(
      DateTime startDate, DateTime endDate) async {
    try {
      final attendanceData =
          await fetchAttendanceDataForRange(subjectCode!, startDate, endDate);
      await generateExcelReportForRange(
          attendanceData, subjectCode!, startDate, endDate);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Attendance report generated successfully.')),
      );
    } catch (error) {
      print('Error generating report: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate report.')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceDataForRange(
      String subjectCode, DateTime startDate, DateTime endDate) async {
    final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    final response = await Supabase.instance.client
        .from('student_attendance')
        .select()
        .eq('subject_code', subjectCode)
        .eq('division', selectedDiv!)
        .eq('class', selectedClass!)
        .gte('date', formattedStartDate)
        .lte('date', formattedEndDate)
        .order('date')
        .order('created_at'); // Differentiate between lectures

    if (response.isEmpty) {
      throw Exception('Failed to fetch attendance data');
    }
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> generateExcelReportForRange(
      List<Map<String, dynamic>> attendanceData,
      String subjectCode,
      DateTime startDate,
      DateTime endDate) async {
    // Create an Excel workbook
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Attendance Report';

    // Extract unique PRNs and sorted date-lecture combinations
    Map<String, Map<String, List<bool>>> studentAttendanceMap = {};
    List<String> prnList = [];
    Map<String, int> presentCountMap = {};
    List<String> headerList = ['PRN']; // Start with 'PRN' as the first column
    Map<String, List<String>> dateLectureCountMap =
        {}; // Track lectures by date + time

    Set<String> uniqueLectures =
        {}; // Use a set to track unique lecture combinations

    for (var record in attendanceData) {
      String prn = record['prn'];
      String date = record['date'];

      // Extract only up to minutes to group the lectures correctly, ignoring the microseconds
      String createdAt = record['created_at']
          .substring(0, 16); // Extract date + hour and minute
      String dateLectureKey = '$date-$createdAt'; // Unique lecture identifier

      bool status = record['attendance_status'];

      if (!prnList.contains(prn)) prnList.add(prn);

      // Add attendance status for the student on this date-lecture combination
      studentAttendanceMap.putIfAbsent(prn, () => {});
      studentAttendanceMap[prn]!.putIfAbsent(dateLectureKey, () => []);
      studentAttendanceMap[prn]![dateLectureKey]!.add(status);

      // Ensure the lecture is counted only once
      if (!uniqueLectures.contains(dateLectureKey)) {
        uniqueLectures.add(dateLectureKey);
        dateLectureCountMap.putIfAbsent(date, () => []);
        dateLectureCountMap[date]!.add(createdAt);
      }

      // Count the number of present days for each student
      presentCountMap[prn] = (presentCountMap[prn] ?? 0) + (status ? 1 : 0);
    }

    // Sort PRN list in ascending order
    prnList.sort();

    // Create headers: PRN, Date1, Date1, Date2, etc., plus No. of Days Present and Total Lectures
    dateLectureCountMap.forEach((date, lectures) {
      for (var lecture in lectures) {
        headerList.add(date); // Only the date will appear in the header
      }
    });
    headerList.add("No. of Days Present");
    headerList.add("Total No. of Lectures");

    // Append the header row
    for (int i = 0; i < headerList.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(headerList[i]);
    }

    // Append rows with attendance data for each student
    int rowIndex = 2; // Start from row 2 for student data
    prnList.forEach((prn) {
      sheet.getRangeByIndex(rowIndex, 1).setText(prn); // PRN column
      int columnIndex = 2; // Start from column 2 for dates + lectures

      dateLectureCountMap.forEach((date, lectures) {
        lectures.forEach((lectureId) {
          String dateLectureKey = '$date-$lectureId';
          List<bool>? attendanceStatuses =
              studentAttendanceMap[prn]?[dateLectureKey];
          if (attendanceStatuses != null && attendanceStatuses.isNotEmpty) {
            sheet
                .getRangeByIndex(rowIndex, columnIndex)
                .setNumber(attendanceStatuses.first ? 1 : 0);
          } else {
            sheet.getRangeByIndex(rowIndex, columnIndex).setNumber(0);
          }
          columnIndex++;
        });
      });

      // Add "No. of Days Present" and "Total Lectures" columns
      sheet
          .getRangeByIndex(rowIndex, columnIndex)
          .setNumber(presentCountMap[prn]?.toDouble() ?? 0);
      sheet
          .getRangeByIndex(rowIndex, columnIndex + 1)
          .setNumber(uniqueLectures.length.toDouble()); // Total unique lectures

      rowIndex++;
    });

    // Auto-fit each column based on content
    for (int i = 1; i <= headerList.length; i++) {
      sheet.autoFitColumn(i);
    }

    // Save the Excel workbook to a file
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final directory = await getApplicationDocumentsDirectory();
    String filePath =
        '${directory.path}/attendance_report_${DateFormat('yyyy-MM-dd').format(startDate)}_to_${DateFormat('yyyy-MM-dd').format(endDate)}.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    print('Excel file generated: $filePath');

    // Open the generated file
    await OpenFile.open(filePath);
  }
}
