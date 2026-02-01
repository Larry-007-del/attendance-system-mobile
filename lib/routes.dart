import 'package:flutter/cupertino.dart';
import 'package:project/screens/chooseCourse/ChoosenCourse.dart';
import 'package:project/screens/Attendance_screen/Attendance.dart';
import 'package:project/screens/Attendance_screen/AttendanceDetails.dart';
import 'package:project/screens/Timetable/TimeTable.dart';
import 'package:project/screens/biometric/Biometric.dart';
import 'package:project/screens/login_screen/login_screen.dart';
import 'package:project/screens/login_screen/signup_screen.dart';
import 'package:project/screens/splash_screen/splash_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';

Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  login_screen.routeName: (context) => login_screen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  Attendance.routeName: (context) => Attendance(),
  SignupScreen.routeName: (context) => SignupScreen(),
  AttendanceDetails.routeName: (context) => AttendanceDetails(),
  Biometric.routeName: (context) => Biometric(),
  TimeTable.routeName: (context) => TimeTable(),
  ChoosenCourse.routeName: (context) => ChoosenCourse(),
};
