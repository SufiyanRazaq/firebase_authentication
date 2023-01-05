import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_practice/auth_service.dart';
import 'package:my_practice/home_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:my_practice/loginscreen.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController Email = TextEditingController();

  TextEditingController Password = TextEditingController();

  TextEditingController ConfirmPassword = TextEditingController();

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
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: ConfirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'ConfirmPassword',
              ),
            ),
            SizedBox(
              height: 20,
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
                          } else if (Password.text != ConfirmPassword.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("password dont match !"),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            User? Result = await AuthService()
                                .register(Email.text, Password.text, context);
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
                  ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Already have an Account ? Login here')),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            loading
                ? CircularProgressIndicator()
                : SignInButton(Buttons.Google, text: "Continue with Google",
                    onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await AuthService().SignInWithGoogle();
                    setState(() {
                      loading = false;
                    });
                  })
          ],
        ),
      ),
    );
  }
}
