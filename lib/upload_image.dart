import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;
  Future<void> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);

    if (pickedImage == null) {
      return null;
    }
    String filename = pickedImage.name;
    File imagefile = File(pickedImage.path);
    try {
      setState(() {
        loading = true;
      });
      await firebaseStorage.ref(filename).putFile(imagefile);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Successfully Uploaded')));
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload to firebase storage'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          uploadImage('camera');
                        },
                        icon: Icon(Icons.camera),
                        label: Text('Camera'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          uploadImage('gallery');
                        },
                        icon: Icon(Icons.library_add),
                        label: Text('Gallery'),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
