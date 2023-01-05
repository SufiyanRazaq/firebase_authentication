import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String id;
  String title;
  String description;
  Timestamp date;
  String userid;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userid,
  });
  factory NoteModel.fromJson(DocumentSnapshot snapshot) {
    return NoteModel(
        id: snapshot.id,
        title: snapshot["title"],
        description: snapshot['description'],
        date: snapshot['data'],
        userid: snapshot['userId']);
  }
}
