import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyProfileScreen());
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

class MyProfileScreen extends StatefulWidget {

  static String routeName = 'MyProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MyProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('images/profile.png'), // Replace with your image
            ),
            SizedBox(height: 16.0),

            Text(
              'ID: ${user?.uid ?? 'N/A'}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<Students?>(
              future: getStudentData(user?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  Students student = snapshot.data!;
                  return Card(
                    //elevation: 2.0,
                    //margin: EdgeInsets.all(7.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                          child : Text(
                            'Student Data',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),

                          SizedBox(height: 10.0),

                          ListTile(
                            title: Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),
                            ),
                            subtitle: Text('${student.name}',style: TextStyle(fontSize: 15),),
                          ),

                          Divider(),

                          ListTile(
                            title: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),
                            ),
                            subtitle: Text('${student.email}',style: TextStyle(fontSize: 15),),
                          ),

                          Divider(),

                          ListTile(
                            title: Text(
                              'Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),
                            ),
                            subtitle: Text('${student.phone}',style: TextStyle(fontSize: 15),),
                          ),
                          // Add more ListTile widgets for additional fields
                        ],
                      ),
                    ),
                  );

                } else {
                  return SizedBox.shrink();
                }
              },
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
    DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(userId)
        .get();

    if (studentSnapshot.exists) {
      return Students(
        name: studentSnapshot['name'],
        phone: studentSnapshot['phone'],
        email: studentSnapshot['email'],
      );
    }
    else {
      print('Student data not found for user: $userId');
      return null;
    }
  } catch (e) {
    print('Error fetching student data: $e');
    return null;
  }
}

