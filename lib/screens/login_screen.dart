import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home_Screen.dart';
import 'Register_Screen.dart';
import '../constants.dart' as Constants;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
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
                  Constants.LOGIN_TEXT,
                  style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
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
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(Constants.LOGIN_FAIL),
                          content: Text('${e.message}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text(Constants.TRY_AGAIN_TEXT),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  color: Colors.blue,
                  child: const Text(
                    Constants.LOGIN_TEXT,
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
                          builder: (context) => SignupScreen(),
                        ));
                      },
                      child: const Text(Constants.SIGNUP_TEXT),
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
