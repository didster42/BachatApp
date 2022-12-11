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

  // Contains data for the pie chart code, later we will get this mapping right from our database
  Map<String, double> tempCostMapping = {
    "Food": 42,
    "Subscriptions": 69,
    "Miscellaneous": 20
  };

  // Map<String, double> costMapping = {
  //   'food': 1,
  //   'travel': 1,
  //   'groceries': 1,
  //   'others': 1
  // };

  // List of colors for the pie chart, could try creating a colour palette generator function
  // which would add more colours as more items are added, so that it fits with whatever
  // color scheme we choose
  List<Color> tempCostChartColors = [
    Color.fromRGBO(129, 145, 171, 1),
    Color.fromRGBO(193, 207, 229, 1),
    Color.fromRGBO(56, 77, 111, 1),
    Color.fromRGBO(15, 33, 61, 1)
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('/categoryExpenseList')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        // this is where I add code for adding stuff to the data which makes the pie chart.
        final docData = doc.data() as Map<String, dynamic>;

        setState(() {
          costMapping.value[doc.id] = docData['totalAmount'].toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      db
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('/categoryExpenseList')
          .get()
          .then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          // this is where I add code for adding stuff to the data which makes the pie chart.
          final docData = doc.data() as Map<String, dynamic>;

          setState(() {
            costMapping.value[doc.id] = docData['totalAmount'].toDouble();
          });
        }

        costMapping.notifyListeners();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Expense Analysis",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: ValueListenableBuilder(
                valueListenable: costMapping,
                builder: (context, value, child) {
                  return PieChart(
                      dataMap: costMapping.value,
                      chartRadius: 250,
                      colorList: tempCostChartColors,
                      legendOptions: LegendOptions(
                          showLegendsInRow: true,
                          legendTextStyle: TextStyle(fontSize: 10),
                          legendPosition: LegendPosition.bottom),
                      chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          chartValueStyle:
                              TextStyle(color: Colors.white, fontSize: 10)));
                },
              ))
        ],
      )),
    );
  }
}
