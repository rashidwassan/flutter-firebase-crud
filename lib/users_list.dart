import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  Stream<List<User>> readUsers() =>
      FirebaseFirestore.instance.collection('students').snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => User.fromJson(doc.data())).toList(),
          );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
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
              return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(snapshot.data![0].name),
                ),
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
