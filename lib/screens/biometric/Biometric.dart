import 'package:flutter/material.dart';
import 'package:project/screens/Attendance_screen/AttendanceDetails.dart';
import 'authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Biometric(),
    );
  }
}

class Biometric extends StatefulWidget {
  static String routeName = 'Biometric';
  const Biometric({super.key});

  @override
  State<Biometric> createState() => _BiometricState();
}

import 'package:geolocator/geolocator.dart';
import 'package:project/services/api_service.dart';

class _BiometricState extends State<Biometric> {
  final TextEditingController _tokenController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _statusMessage = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _processAttendance() async {
    if (_tokenController.text.isEmpty) {
      setState(() {
        _statusMessage = "Please enter the session token.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "Authenticating Biometrics...";
    });

    try {
      bool auth = await Authentication.authentication();
      if (!auth) {
        setState(() {
          _isLoading = false;
          _statusMessage = "Biometric Authentication Failed.";
        });
        return;
      }

      setState(() {
        _statusMessage = "Acquiring Location...";
      });

      Position position = await _determinePosition();

      setState(() {
        _statusMessage = "Submitting Attendance...";
      });

      final result = await _apiService.markAttendance(
        _tokenController.text,
        position.latitude,
        position.longitude,
      );

      setState(() {
        _isLoading = false;
        _statusMessage = result['message'];
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Attendance Marked Successfully!")),
        );
        Navigator.pushReplacementNamed(context, AttendanceDetails.routeName);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 52, 134),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Attendance Verification",
                style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _tokenController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Enter Session Token",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.key, color: Colors.white70),
                ),
              ),
              SizedBox(height: 28),
              if (_isLoading)
                CircularProgressIndicator(color: Colors.white)
              else
                ElevatedButton.icon(
                  onPressed: _processAttendance,
                  icon: Icon(Icons.fingerprint),
                  label: Text("Authenticate & Mark"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                _statusMessage,
                style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
