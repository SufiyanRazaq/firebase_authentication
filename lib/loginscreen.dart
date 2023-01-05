import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController Email = TextEditingController();

  TextEditingController Password = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: Email,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: Password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            loading
                ? CircularProgressIndicator()
                : Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (Email.text == "" || Password.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All fields are required !"),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            User? Result = await AuthService()
                                .login(Email.text, Password.text, context);
                            if (Result != null) {
                              print("Success");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home_Screen(Result)),
                                  (route) => false);
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )),
                  )
          ],
        ),
      ),
    );
  }
}
