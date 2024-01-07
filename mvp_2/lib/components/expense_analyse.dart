// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

ValueNotifier<Map<String, double>> costMapping =
    ValueNotifier({'food': 1, 'travel': 1, 'groceries': 1, 'others': 1});

class ExpenseAnalysis extends StatefulWidget {
  const ExpenseAnalysis({super.key});

  @override
  State<ExpenseAnalysis> createState() => _ExpenseAnalysisState();
}

class _ExpenseAnalysisState extends State<ExpenseAnalysis>
    with WidgetsBindingObserver {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1.0,
                    spreadRadius: 0.5,
                    color: Color.fromRGBO(0, 0, 0, 0.1))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("Expense Analysis",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
              )
            ]),
          ),
        ));
  }
}
