import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/data_entry_page.dart';
import 'package:flutter_firebase/models/user.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  Stream<List<User>> readUsers() =>
      FirebaseFirestore.instance.collection('students').snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => User.fromJson(doc.data())).toList(),
          );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Students Enrolled'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataEntryScreen())),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          // provide the method here which returns a stream
          stream: readUsers(),
          // define here what type of data the snapshot contains
          builder: (context, AsyncSnapshot<List<User>> snapshot) {
            // if connection is waiting, there should be circular progress indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return StudentsList(
                  studentList: snapshot.data ?? [],
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}

class StudentsList extends StatelessWidget {
  const StudentsList({
    required this.studentList,
    super.key,
  });

  final List<User> studentList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: studentList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(studentList[index].name),
            subtitle: Text('Age: ${studentList[index].age}'),
            trailing: Text('${studentList[index].educationalYears}'),
          ),
        ),
      ),
    );
  }
}
