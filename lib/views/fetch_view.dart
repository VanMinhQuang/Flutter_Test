import 'package:bai4/model/student.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class FetchView extends StatefulWidget {
  const FetchView({super.key});

  @override
  State<FetchView> createState() => _FetchViewState();
}

class _FetchViewState extends State<FetchView> {
  late final TextEditingController _id;
  late final TextEditingController _name;
  late final TextEditingController _gpa;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = TextEditingController();
    _name = TextEditingController();
    _gpa = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _id.dispose();
    _name.dispose();
    _gpa.dispose();
  }

  void deleteData(String id) {
    final databaseRef = FirebaseDatabase.instance.ref().child('Students');
    databaseRef.child(id).remove();
  }

  void updateData(Student student) {
    final databaseRef = FirebaseDatabase.instance.ref().child('Students');
    databaseRef.child(student.id.toString()).update(student.toJson());
  }

  Future<void> showDeleteDialog(String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Are you sure you want to delete $id'),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteData(id);
                  },
                  child: const Text('Delete'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ]),
        ));
      },
    );
  }

  Future<void> showMydialog(String id, String name, String gpa) async {
    _id.text = id;
    _name.text = name;
    _gpa.text = gpa;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: Column(children: <Widget>[
            TextField(
              controller: _id,
              enabled: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter ID'),
            ),
            TextField(
              controller: _name,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(hintText: 'Enter Name'),
            ),
            TextField(
              controller: _gpa,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              decoration: const InputDecoration(hintText: 'Enter GPA'),
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Student student = Student(
                    id: _id.text,
                    name: _name.text,
                    gpa: double.parse(_gpa.text));
                updateData(student);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('cancle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Row(
                children: <Widget>[
                  Expanded(
                      child: FirebaseAnimatedList(
                    query: FirebaseDatabase.instance.ref("Students"),
                    itemBuilder: (context, snapshot, animation, index) {
                      return ListTile(
                        title: Text(snapshot.child('id').value.toString()),
                        subtitle: Row(
                          children: <Widget>[
                            Text(
                                '${snapshot.child('name').value.toString()}: ${snapshot.child('gpa').value.toString()}'),
                            GestureDetector(
                              onTap: () {
                                showMydialog(
                                    snapshot.child('id').value.toString(),
                                    snapshot.child('name').value.toString(),
                                    snapshot.child('gpa').value.toString());
                              },
                              child: Row(children: [
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDeleteDialog(
                                    snapshot.child('id').value.toString());
                              },
                              child: Row(children: [
                                Icon(
                                  Icons.remove,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ]),
                            )
                          ],
                        ),
                      );
                    },
                  ))
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
