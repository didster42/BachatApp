// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String topText = "";
String bottomText = "";
double topCost = -1;
double bottomCost = -1;

/* Recent Expenses Widget */

class RecentExpenses extends StatefulWidget {
  const RecentExpenses({super.key});

  @override
  State<RecentExpenses> createState() => _RecentExpensesState();
}

class _RecentExpensesState extends State<RecentExpenses>
    with WidgetsBindingObserver {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final userRef =
        db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

    final query = userRef
        .collection('expenseList')
        .orderBy('timeOfPayment', descending: true)
        .limit(2);

    query.get().then((QuerySnapshot snapshot) {
      final firstData = snapshot.docs.first.data() as Map<String, dynamic>;
      final secondData = snapshot.docs.last.data() as Map<String, dynamic>;

      setState(() {
        topText = firstData['upiId'];
        bottomText = secondData['upiId'];

        topCost = firstData['amountPaid'].toDouble();
        bottomCost = secondData['amountPaid'].toDouble();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//// override this function
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final userRef =
          db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

      final query = userRef
          .collection('expenseList')
          .orderBy('timeOfPayment', descending: true)
          .limit(2);

      query.get().then((QuerySnapshot snapshot) {
        final firstData = snapshot.docs.first.data() as Map<String, dynamic>;
        final secondData = snapshot.docs.last.data() as Map<String, dynamic>;

        setState(() {
          topText = firstData['upiId'];
          bottomText = secondData['upiId'];

          topCost = firstData['amountPaid'].toDouble();
          bottomCost = secondData['amountPaid'].toDouble();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text("Latest Expenditures",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Row(
                        children: [
                          Container(child: Icon(Icons.local_pizza, size: 35)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topText, style: TextStyle(fontSize: 17)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.5),
                                  child: Text("Food",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                      Container(
                          child: Row(
                        children: [
                          Text("₹ ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.5)),
                          Text(topCost.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.5))
                        ],
                      ))
                    ],
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Row(
                        children: [
                          Container(child: Icon(Icons.local_pizza, size: 35)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bottomText,
                                    style: TextStyle(fontSize: 17)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.5),
                                  child: Text("Food",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                      Container(
                          child: Row(
                        children: [
                          Text("₹ ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.5)),
                          Text(bottomCost.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.5))
                        ],
                      ))
                    ],
                  ),
                )),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 15, color: Color.fromRGBO(15, 33, 61, 1)),
                  ),
                  onPressed: () {},
                  child: Text("See More"),
                ),
              )
            ],
          )),
    );
  }
}
