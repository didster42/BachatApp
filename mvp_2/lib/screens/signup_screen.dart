// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(15, 33, 61, 1),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: const Text("Bachat",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40,
                      letterSpacing: 3.5)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                children: [
                  TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Email",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                          fillColor: Colors.redAccent)),
                  const SizedBox(height: 30),
                  TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Name",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                          fillColor: Colors.redAccent)),
                  const SizedBox(height: 30),
                  TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Password",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                          fillColor: Colors.redAccent)),
                  const SizedBox(height: 25),
                  const SizedBox(height: 25),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Already have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Login!"))
                  ]),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: SignUp,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(),
                        child: Text("Sign up"),
                      ))
                ],
              ),
            ),
          ])),
    );
  }

  Future SignUp() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) {
      final user = <String, dynamic>{
        'name': nameController.text.trim(),
        'monthlyExpenses': 0.0,
        'weeklyExpenses': 0.0,
        'budget': 3000.0
      };

      db
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .set(user)
          .then(((value) {
        print("User onboarded successfully");

        // db
        //     .collection('/users')
        //     .doc(FirebaseAuth.instance.currentUser?.email)
        //     .collection('/expenseList')
        //     .doc()
        //     .set({});
      })).onError((error, stackTrace) {
        print("Error: $error");
      });
    });
  }
}
