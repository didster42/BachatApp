// ignore_for_file: prefer_const_constructors
import 'package:mvp_2/components/sms_module.dart';
import 'package:flutter/material.dart';
import 'package:mvp_2/screens/login_screen.dart';
import 'package:mvp_2/screens/signup_screen.dart';
import './screens/home_screen.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (Navigator.canPop(context)) Navigator.pop(context);
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            }));
  }
}
