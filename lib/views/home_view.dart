// ignore: import_of_legacy_library_into_null_safe

import 'dart:html';

import 'package:bai4/views/fetch_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../model/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _id;
  late final TextEditingController _name;
  late final TextEditingController _gpa;
  late List<Student> lstStudent;
  // ignore: prefer_typing_uninitialized_variables
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = TextEditingController();
    _name = TextEditingController();
    _gpa = TextEditingController();
    lstStudent = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _id.dispose();
    _name.dispose();
    _gpa.dispose();
  }

  Future<List<Student>> getData() async {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    lstStudent.clear();
    final databaseRef = FirebaseDatabase.instance.ref().child('Students');
    databaseRef.once().then((value) => {
          setState(
            () {
              Map<dynamic, dynamic> values = value.snapshot.value as Map;
              values.forEach((key, value) {
                Student student = Student.fromJson(value);
                lstStudent.add(student);
              });
            },
          )
        });
    return lstStudent;
  }

  void uploadData(Student student) {
    final databaseRef = FirebaseDatabase.instance.ref().child('Students');
    databaseRef.child(student.id.toString()).set(student.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  return Column(
                    children: <Widget>[
                      TextField(
                        controller: _id,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Enter ID'),
                      ),
                      TextField(
                        controller: _name,
                        keyboardType: TextInputType.name,
                        decoration:
                            const InputDecoration(hintText: 'Enter Name'),
                      ),
                      TextField(
                        controller: _gpa,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration:
                            const InputDecoration(hintText: 'Enter GPA'),
                      ),
                      TextButton(
                          onPressed: () {
                            Student student = Student(
                                id: _id.text,
                                name: _name.text,
                                gpa: double.parse(_gpa.text));
                            uploadData(student);
                          },
                          child: const Text('upload')),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const FetchView(),
                            ));
                          },
                          child: const Text('Go to fetch View')),
                    ],
                  );
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
