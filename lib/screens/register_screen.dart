import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../constants.dart' as Constants;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  Constants.SIGNUP_TEXT,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60.0,
                      color: Colors.blue),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: Constants.EMAIL_TEXT,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: pwController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: Constants.PASSWORD_TEXT,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  onPressed: () async {
                    try {
                      email = emailController.text;
                      password = pwController.text;
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(Constants.SIGNUP_FAIL),
                          content: Text('${e.message}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text(Constants.TRY_AGAIN_TEXT),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  color: Colors.blue,
                  child: const Text(
                    Constants.SIGNUP_TEXT,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                      },
                      child: const Text(Constants.LOGIN_TEXT),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
