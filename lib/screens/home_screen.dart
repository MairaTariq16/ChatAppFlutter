import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'login_screen.dart';
import '../constants.dart' as Constants;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              Constants.LOGIN_SUCCESS,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 50),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  children: [
                    ElevatedButton(
                        child: const Center(
                          child: Text(Constants.SEARCH_TEXT),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()),
                          );
                        }),
                    ElevatedButton(
                        child: const Center(
                          child: Text(Constants.LOGOUT_TEXT),
                        ),
                        onPressed: () async {
                          await _firebaseAuth.signOut();
                          if (_firebaseAuth.currentUser == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
