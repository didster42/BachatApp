// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'expenses_shower.dart';
import 'package:intl/intl.dart';

//ValueNotifier<List<Map<String, dynamic>>> expenseList = ValueNotifier([]);
List<Map<String, dynamic>> expenseList = [];
Map<int, List<Map<String, dynamic>>> monthExpenseList = {};
Map<int, List<dynamic>> indexMonth = {};

String topText = "";
String bottomText = "";
String topDate = "";
String bottomDate = "";
String topTime = "";
String bottomTime = "";
double topCost = 0;
double bottomCost = 0;

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

    monthExpenseList = {};
    expenseList = [];
    indexMonth = {};
    topText = "";
    bottomText = "";
    topTime = "";
    bottomTime = "";
    topDate = "";
    bottomDate = "";
    topCost = 0;
    bottomCost = 0;

    final userRef =
        db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

    userRef.get().then((DocumentSnapshot docSnap) {
      // two cases, if the indexed month has 1 payment, or 2 payments
      // if one payment, then
      // if this is index = 1, then just display one payment, else just add the recent most payment
      // in the previous month if that exists

      userRef
          .collection('/monthlyExpenses')
          .orderBy('indexNum', descending: true)
          .get()
          .then((QuerySnapshot querySnap) {
        if (querySnap.size > 0) {
          // for (var queryDoc in querySnap.docs) {
          debugPrint("The size of the querySnap is ${querySnap.size}");
          for (int j = 0; j < querySnap.docs.length; j++) {
            var queryDoc = querySnap.docs[j];

            String currentMonth = querySnap.docs[j]['month'];
            int currentYear = querySnap.docs[j]['year'];

            // updating index month map list
            indexMonth[j + 1] = [];
            indexMonth[j + 1]!.add(querySnap.docs[j]['month']);
            indexMonth[j + 1]!.add(querySnap.docs[j]['year']);

            queryDoc.reference
                .collection('/monthExpenseDocuments')
                .orderBy('timeOfPayment', descending: true)
                .get()
                .then((QuerySnapshot queryExpenseSnap) {
              if (j == 0) {
                if (queryExpenseSnap.size >= 2) {
                  final firstData =
                      queryExpenseSnap.docs[0].data() as Map<String, dynamic>;

                  final secondData =
                      queryExpenseSnap.docs[1].data() as Map<String, dynamic>;

                  setState(() {
                    topText = firstData['upiId'];
                    topCost = firstData['amountPaid'].toDouble();
                    topDate = "${firstData['day']} $currentMonth $currentYear";
                    topTime = DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            firstData['timeOfPayment']));

                    bottomText = secondData['upiId'];
                    bottomCost = secondData['amountPaid'].toDouble();
                    bottomDate =
                        "${secondData['day']} $currentMonth $currentYear";
                    bottomTime = DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            secondData['timeOfPayment']));
                  });
                } else if (queryExpenseSnap.size == 1) {
                  final firstData =
                      queryExpenseSnap.docs[0].data() as Map<String, dynamic>;

                  setState(() {
                    topText = firstData['upiId'];
                    topCost = firstData['amountPaid'].toDouble();
                    topDate = topDate =
                        "${firstData['day']} $currentMonth $currentYear";
                    topTime = DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            firstData['timeOfPayment']));
                  });
                }
              }

              for (int i = 0; i < queryExpenseSnap.size; i++) {
                final docData =
                    queryExpenseSnap.docs[i].data() as Map<String, dynamic>;

                if (!monthExpenseList.containsKey(j + 1)) {
                  monthExpenseList[j + 1] = [];
                }
                monthExpenseList[j + 1]?.add({
                  'paymentTo': docData['upiId'],
                  'amountPaid': docData['amountPaid'],
                  'timeOfPayment': docData['timeOfPayment'],
                  'day': docData['day']
                });
              }

              debugPrint(
                  "The month expense list is ${monthExpenseList.length}");
            });
          }
        }
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
      // making the local lists empty
      monthExpenseList = {};
      indexMonth = {};

      final userRef =
          db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

      userRef.get().then((DocumentSnapshot docSnap) {
        // two cases, if the indexed month has 1 payment, or 2 payments
        // if one payment, then
        // if this is index = 1, then just display one payment, else just add the recent most payment
        // in the previous month if that exists

        userRef
            .collection('/monthlyExpenses')
            .orderBy('indexNum', descending: true)
            .get()
            .then((QuerySnapshot querySnap) {
          if (querySnap.size > 0) {
            debugPrint("The size of the querySnap is ${querySnap.size}");
            for (int j = 0; j < querySnap.docs.length; j++) {
              var queryDoc = querySnap.docs[j];

              String currentMonth = querySnap.docs[j]['month'];
              int currentYear = querySnap.docs[j]['year'];

              // updating index month map list
              indexMonth[j + 1] = [currentMonth, currentYear];

              queryDoc.reference
                  .collection('/monthExpenseDocuments')
                  .orderBy('timeOfPayment', descending: true)
                  .get()
                  .then((QuerySnapshot queryExpenseSnap) {
                if (j == 0) {
                  if (queryExpenseSnap.size >= 2) {
                    final firstData =
                        queryExpenseSnap.docs[0].data() as Map<String, dynamic>;

                    final secondData =
                        queryExpenseSnap.docs[1].data() as Map<String, dynamic>;

                    setState(() {
                      topText = firstData['upiId'];
                      topCost = firstData['amountPaid'].toDouble();
                      topDate =
                          "${firstData['day']} $currentMonth $currentYear";
                      topTime = DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              firstData['timeOfPayment']));

                      bottomText = secondData['upiId'];
                      bottomCost = secondData['amountPaid'].toDouble();
                      bottomDate =
                          "${secondData['day']} $currentMonth $currentYear";
                      bottomTime = DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              secondData['timeOfPayment']));
                    });
                  } else if (queryExpenseSnap.size == 1) {
                    final firstData =
                        queryExpenseSnap.docs[0].data() as Map<String, dynamic>;

                    setState(() {
                      topText = firstData['upiId'];
                      topCost = firstData['amountPaid'].toDouble();
                      topDate =
                          "${firstData['day']} $currentMonth $currentYear";
                      topTime = DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              firstData['timeOfPayment']));
                    });
                  }
                }

                for (int i = 0; i < queryExpenseSnap.size; i++) {
                  final docData =
                      queryExpenseSnap.docs[i].data() as Map<String, dynamic>;

                  if (!monthExpenseList.containsKey(j + 1)) {
                    monthExpenseList[j + 1] = [];
                  }
                  monthExpenseList[j + 1]?.add({
                    'paymentTo': docData['upiId'],
                    'amountPaid': docData['amountPaid'],
                    'timeOfPayment': docData['timeOfPayment'],
                    'day': docData['day']
                  });
                }

                debugPrint(
                    "The month expense list is ${monthExpenseList.length}");
              });
            }
          }
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
                          Container(child: Icon(Icons.wallet, size: 30)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topText.trim(),
                                    style: TextStyle(fontSize: 15)),
                                Row(
                                  children: [
                                    Text(topDate,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromARGB(
                                                255, 132, 132, 132))),
                                    SizedBox(width: 5),
                                    Text(topTime,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromARGB(
                                                255, 132, 132, 132))),
                                  ],
                                ),
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
              SizedBox(height: 5),
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
                          Container(child: Icon(Icons.wallet, size: 30)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bottomText.trim(),
                                    style: TextStyle(fontSize: 15)),
                                Row(
                                  children: [
                                    Text(bottomDate,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromARGB(
                                                255, 132, 132, 132))),
                                    SizedBox(width: 5),
                                    Text(bottomTime,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromARGB(
                                                255, 132, 132, 132))),
                                  ],
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpenseShower()));
                  },
                  child: Text("See More"),
                ),
              )
            ],
          )),
    );
  }
}
