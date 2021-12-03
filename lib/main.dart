import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_test_app/screens/register_screen.dart';
import 'package:firebase_test_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Database database = Database();

  @override
  void initState() {
    getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("onMessage: $message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("onLaunch: $message");
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });

    super.initState();
  }

  void getToken() async {
    token = (await firebaseMessaging.getToken())!;
    print("Tokennnnnnnn: $token");
    database.setDeviceToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignupScreen(),
    );
  }
}

class MessageArguments {
  MessageArguments(RemoteMessage message, bool bool);
}
