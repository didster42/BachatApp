import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

double budget = 3000;

class SetBudget extends StatefulWidget {
  const SetBudget({super.key});

  @override
  State<SetBudget> createState() => _SetBudgetState();
}

class _SetBudgetState extends State<SetBudget> {
  final db = FirebaseFirestore.instance;

  String budgetUpdateText = "";

  void initState() {
    super.initState();

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      final docData = snapshot.data() as Map<String, dynamic>;

      budget = docData['budget'];
    });
  }

  void SetBudgetValue() {
    // Budget Update Text
    setState(() {
      budgetUpdateText = "Budget Updated Successfully";

      Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          budgetUpdateText = "";
        });
      });
    });

    // update budget data on firestore

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .update({'budget': budget})
        .then((value) => print("Budget updated successfully!"))
        .onError((error, stackTrace) => print("There was an error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Budget Setter", style: TextStyle(fontSize: 25)),
            SizedBox(height: 50),
            Text(budget.toStringAsFixed(0),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Slider(
                min: 0,
                max: 15000,
                value: budget,
                divisions: 15,
                activeColor: Color.fromRGBO(15, 33, 61, 1),
                onChanged: (newValue) {
                  setState(() {
                    budget = newValue;
                  });
                }),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: SetBudgetValue, child: Text("Set Budget!")),
            SizedBox(height: 20),
            Text(budgetUpdateText, style: TextStyle(color: Colors.green))
          ],
        ));
  }
}
