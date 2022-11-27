// ignore_for_file: prefer_const_constructors
import 'package:mvp_2/components/sms_module.dart';
import 'package:flutter/material.dart';
import 'package:mvp_2/screens/login_screen.dart';
import 'package:mvp_2/screens/signup_screen.dart';
import './screens/home_screen.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
