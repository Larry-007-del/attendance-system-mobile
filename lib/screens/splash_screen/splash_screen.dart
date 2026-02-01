import 'package:project/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, login_screen.routeName, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image.asset(
      'images/splash.png',
      height: 25.h,
      width: 50.w,
    )));
  }
}
