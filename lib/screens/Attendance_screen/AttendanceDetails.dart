import 'package:flutter/material.dart';
import 'package:project/services/api_service.dart';

class AttendanceDetails extends StatefulWidget {
  static String routeName = 'AttendanceDetails';
  const AttendanceDetails({super.key});

  @override
  _AttendanceDetailsState createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  late Future<List<dynamic>> historyFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    historyFuture = _apiService.getAttendanceHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance History'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: historyFuture,
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No attendance records found.'));
          } else {
             final records = snapshot.data!;
             return ListView.builder(
               itemCount: records.length,
               itemBuilder: (context, index) {
                 final courseData = records[index];
                 final courseCode = courseData['course_code'];
                 final attendances = courseData['attendances'] as List;
                 
                 return ExpansionTile(
                   title: Text(courseCode ?? 'Unknown Course'),
                   subtitle: Text('Total Present: ${attendances.length}'),
                   children: attendances.map<Widget>((att) {
                     return ListTile(
                       title: Text(att['date'] ?? ''),
                       leading: const Icon(Icons.check_circle, color: Colors.green),
                     );
                   }).toList(),
                 );
               }
             );
          }
        },
      )
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttendanceDetails(),
  ));
}