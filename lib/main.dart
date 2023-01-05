import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_practice/auth_service.dart';
import 'package:my_practice/home_screen.dart';
import 'package:my_practice/homepage.dart';
import 'package:my_practice/upload_image.dart';

//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //    options: DefaultFirebaseOptions.currentPlatform, name: "FlutterFirebase"
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(brightness: Brightness.dark),
      home: StreamBuilder(
          stream: AuthService().firebaseAuth.authStateChanges(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              //   return UploadImage();
              return Home_Screen(snapshot.data);
            }
            return homepage();
          }),
    );
  }
}
