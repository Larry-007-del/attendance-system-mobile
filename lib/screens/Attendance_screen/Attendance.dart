import 'package:flutter/material.dart';
import 'package:project/screens/biometric/Biometric.dart';
import 'package:project/services/api_service.dart';

class Attendance extends StatefulWidget {
  static String routeName = 'Attendance';
  const Attendance({super.key});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late Future<List<dynamic>> coursesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    coursesFuture = _apiService.getEnrolledCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses found.'));
          } else {
            List<dynamic> courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      course['name'] ?? 'Unknown Course',
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(course['course_code'] ?? ''),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Biometric.routeName,
                        // arguments: course,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle submitting the attendance data (save to database, etc.)
      //     print('Attendance Submitted');
      //   },
      // ),
    );
  }
}
