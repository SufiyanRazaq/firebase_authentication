import 'package:flutter/material.dart';
import 'package:my_practice/firestore_service.dart';

import 'note.dart';

class EditNote extends StatefulWidget {
  EditNote(this.note);
  NoteModel note;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController description = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    titleController.text = widget.note.title;
    description.text = widget.note.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Please confirm'),
                      content: Text('Are you sure to delete the note ?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await FirestoreService()
                                  .deleteNote(widget.note.id);
//close the dialog
                              Navigator.pop(context);
//close the edit screen
                              Navigator.pop(context);
                            },
                            child: Text('Yes')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'))
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: description,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (titleController.text == "" ||
                                description.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('All fields are required !')));
                            } else {
                              setState(() {
                                loading = true;
                              });
                              await FirestoreService().updateNote(
                                  widget.note.id,
                                  titleController.text,
                                  description.text);
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Text(
                            "Update Data",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
