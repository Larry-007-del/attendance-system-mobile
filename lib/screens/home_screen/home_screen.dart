import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/screens/Attendance_screen/Attendance.dart';
import 'package:project/screens/Timetable/TimeTable.dart';
import 'package:project/screens/my_profile/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class Students {
  final String name;
  final String phone;
  final String email;

  Students({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}

class HomeScreen extends StatelessWidget {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  final kTopBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.tablet ? 40 : 20),
    topRight:
    Radius.circular(SizerUtil.deviceType == DeviceType.tablet ? 40 : 20),
  );

  @override
  Widget build(BuildContext context) {
    // User? user = _auth.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: 100.w,
            height: 40.h,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final prefs = snapshot.data;
                    final String name = prefs?.getString('username') ?? 'Student';
                    
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, MyProfileScreen.routeName);
                          },
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage('images/profile.png'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Hi $name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                //reusable radius,
                borderRadius: kTopBorderRadius,
              ),
              child: SingleChildScrollView(
                //for padding
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, TimeTable.routeName);
                          },
                          icon: 'icons/timetable.svg',
                          title: 'Time Table',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HomeCard(
                          onPress: () {
/////////////////////////////////////////////////////////////////////////////////////////////
                          },
                          icon: 'icons/event.svg',
                          title: 'Events',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, Attendance.routeName);
                          },
                          icon: 'icons/attendance-svgrepo-com.svg',
                          title: 'Attendence',
                        ),
                        HomeCard(
                          onPress: () {
/////////////////////////////////////////////////////////////////////////////////////////////
                          },
                          icon: 'icons/event.svg',
                          title: 'Holiday',
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, Attendance.routeName);
                          },
                          icon: 'icons/attendance-svgrepo-com.svg',
                          title: 'Quiz',
                        ),
                        HomeCard(
                          onPress: () {
/////////////////////////////////////////////////////////////////////////////////////////////
                          },
                          icon: 'icons/event.svg',
                          title: 'Assignment',
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, Attendance.routeName);
                          },
                          icon: 'icons/attendance-svgrepo-com.svg',
                          title: 'Data sheet',
                        ),
                        HomeCard(
                          onPress: () {
/////////////////////////////////////////////////////////////////////////////////////////////
                          },
                          icon: 'icons/event.svg',
                          title: 'Events',
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamed(context, Attendance.routeName);
                          },
                          icon: 'icons/attendance-svgrepo-com.svg',
                          title: 'Attendence',
                        ),
                        HomeCard(
                          onPress: () {
/////////////////////////////////////////////////////////////////////////////////////////////
                          },
                          icon: 'icons/event.svg',
                          title: 'Events',
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard(
      {Key? key,
      required this.onPress,
      required this.icon,
      required this.title})
      : super(key: key);
  final VoidCallback onPress;
  final String icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              width: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              color: Color(0xFFF4F6F7),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5),
            ),
          ],
        ),
      ),
    );
  }
}


Future<Students?> getStudentData(String? userId) async {
  if (userId == null) {
    return null;
  }

  try {
    DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
    await FirebaseFirestore.instance.collection('Students').doc(userId).get();

    if (studentSnapshot.exists) {
      return Students(
        name: studentSnapshot['name'],
        phone: studentSnapshot['phone'],
        email: studentSnapshot['email'],
      );
    } else {
      print('Student data not found for user: $userId');
      return null;
    }
  } catch (e) {
    print('Error fetching student data: $e');
    return null;
  }
}