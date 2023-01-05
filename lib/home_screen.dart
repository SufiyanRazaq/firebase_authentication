import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_practice/add_note.dart';
import 'package:my_practice/auth_service.dart';
import 'package:my_practice/edit_note.dart';
import 'package:my_practice/note.dart';

class Home_Screen extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User user;
  Home_Screen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Home"),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await AuthService().signout();
            },
            icon: Icon(Icons.logout),
            label: Text("sign out"),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notes')
              .where('userId', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.docs.length);
              if (snapshot.data.docs.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    NoteModel note =
                        NoteModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      color: Colors.teal,
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        title: Text(
                          note.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          note.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(note)));
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('No Notes Available'),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNote(user)));
        },
      ),
      /*Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Add data to your firestore'),
              onPressed: () async {
                CollectionReference users = firestore.collection('users');
                await users.doc('flutter123').set({'name': 'google flutter'});
                //  await users.add({'name': 'sufiyan'});
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  CollectionReference users = firestore.collection('users');
                  // await for (var snapshot
                  // in firestore.collection('users').snapshots()) {
                  //   for (var result in snapshot.docs) {
                  //   print(result.data());
                  // }
                  //}
                  users.doc('flutter123').snapshots().listen((result) {
                    //     print(result.data());
                    //  }
                    //   DocumentSnapshot result = await users.doc('flutter123').get();
                    print(result.data());
                  });
                },
                child: Text('Read Data from firestore')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await firestore
                      .collection('users')
                      .doc('flutter123')
                      .update({'name': "sufiyanRazaq"});
                },
                child: Text('Update your data in firebase')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await firestore
                      .collection('users')
                      .doc('flutter123')
                      .delete();
                },
                child: Text('Delete the Data from firestore'))
          ],
        ),
      ),*/
    );
  }
}
