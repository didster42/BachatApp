import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromRGBO(15, 33, 61, 1),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Bachat",
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
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Email",
                              style: TextStyle(color: Colors.grey)),
                          fillColor: Colors.redAccent)),
                  const SizedBox(height: 25),
                  TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          label: Text("Password",
                              style: TextStyle(color: Colors.grey)),
                          fillColor: Colors.redAccent)),
                  const SizedBox(height: 25),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Already have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(onPressed: () {}, child: const Text("Login!"))
                  ]),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: (() {}),
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
}
