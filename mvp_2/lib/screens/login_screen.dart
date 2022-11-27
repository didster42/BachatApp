// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromRGBO(15, 33, 61, 1),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Bachat",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40,
                    letterSpacing: 3.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
              child: Column(
                children: [
                  TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Email",
                              style: TextStyle(color: Colors.grey)),
                          fillColor: Colors.redAccent)),
                  SizedBox(height: 25),
                  TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Password",
                              style: TextStyle(color: Colors.grey)),
                          fillColor: Colors.redAccent)),
                  SizedBox(height: 25),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Don't have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(onPressed: () {}, child: Text("Sign up!"))
                  ]),
                  SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: (() {}),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: Text("Login"),
                      ))
                ],
              ),
            ),
          ])),
    );
  }
}
