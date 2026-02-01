import 'package:project/screens/chooseCourse/ChoosenCourse.dart';
import 'package:project/firebase_options.dart';
import 'package:project/routes.dart';
import 'package:project/screens/Attendance_screen/AttendanceDetails.dart';
import 'package:project/screens/home_screen/home_screen.dart';
import 'package:project/screens/login_screen/login_screen.dart';
import 'package:project/screens/my_profile/my_profile.dart';
import 'package:project/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, device) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pharos university',
        initialRoute: HomeScreen.routeName,
        routes: routes,
      );
    });
  }
}
