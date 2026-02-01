import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/home_screen/home_screen.dart';

class Courses {
  final String courseName;
  final int totalClasses;
  int attendedClasses; // Change attendedClasses to be mutable

  Courses({
    required this.courseName,
    required this.totalClasses,
    required this.attendedClasses,
  });

  factory Courses.fromMap(Map<String, dynamic> map) {
    return Courses(
      courseName: map['courseName'],
      totalClasses: map['totalClasses'] ?? 16,
      attendedClasses: map['attendedClasses'] ?? 0,
    );
  }
}

class ChoosenCourse extends StatefulWidget {
  static String routeName = 'ChoosenCourse';

  @override
  _ChoosenCourseState createState() => _ChoosenCourseState();
}

class _ChoosenCourseState extends State<ChoosenCourse> {
  List<Courses> courses = [];
  List<String> selectedCourses = [];

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  void _onCourseSelected(String course) {
    setState(() {
      if (selectedCourses.contains(course)) {
        selectedCourses.remove(course); // Deselect the course if already selected
      } else {
        selectedCourses.add(course); // Select the course if not already selected
      }
    });
  }

  Future<void> fetchCourseData() async {
    try {
      CollectionReference coursesCollection = FirebaseFirestore.instance.collection('Courses');

      QuerySnapshot<Object?> querySnapshot = await coursesCollection.get();

      setState(() {
        courses = querySnapshot.docs
            .map((doc) => Courses.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching course data: $e');
    }
  }

  void _submitSelection() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference studentsCollection =
        FirebaseFirestore.instance.collection('Students');

        DocumentReference userDocument = studentsCollection.doc(user.uid);

        CollectionReference coursesCollection =
        userDocument.collection('Courses');

        for (String courseName in selectedCourses) {
          // Find the selected course in the courses list
          Courses selectedCourse = courses.firstWhere(
                (course) => course.courseName == courseName,
            orElse: () => Courses(courseName: courseName, totalClasses: 0, attendedClasses: 0),
          );

          // Submit the selection with updated attendedClasses
          await coursesCollection.add({
            'courseName': selectedCourse.courseName,
            'totalClasses': selectedCourse.totalClasses,
            'attendedClasses': selectedCourse.attendedClasses,
          });
        }

        print('Selection submitted');
      } else {
        print('User not signed in');
      }
    } catch (e) {
      print('Error submitting selection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses[index].courseName),
            tileColor: selectedCourses.contains(courses[index].courseName)
                ? Colors.blue.withOpacity(0.3)
                : null,
            onTap: () {
              _onCourseSelected(courses[index].courseName);
            },
            trailing: selectedCourses.contains(courses[index].courseName)
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submitSelection();
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
