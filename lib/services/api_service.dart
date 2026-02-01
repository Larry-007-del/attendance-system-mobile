import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access localhost of the host machine.
  // Use your machine's IP if testing on real device.
  final String baseUrl = "https://attendance-system-backend-z1wl.onrender.com"; 
  
  // TODO: Implement proper authentication to get this token
  final String? _authToken = "YOUR_AUTH_TOKEN"; 

  Future<List<dynamic>> getEnrolledCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/student/my-courses/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to load courses: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching courses: $e");
    }
    return [];
  }

  Future<List<dynamic>> getAttendanceHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/student/attendance-history/'),
         headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print("Error fetching history: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> markAttendance(String token, double lat, double long) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/courses/take_attendance/'),
        headers: _headers,
        body: json.encode({
          'token': token,
          'latitude': lat,
          'longitude': long
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Attendance marked successfully'};
      } else {
        final body = json.decode(response.body);
        return {'success': false, 'message': body['error'] ?? 'Unknown error'};
      }
    } catch (e) {
       return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Token $_authToken'
  };
}
