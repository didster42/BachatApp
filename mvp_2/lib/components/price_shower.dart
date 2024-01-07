// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

ValueNotifier<double> monthlyExpenditureValue = ValueNotifier(-1);

class PriceShower extends StatefulWidget {
  const PriceShower({super.key});

  @override
  State<PriceShower> createState() => PriceShowerState();
}

class PriceShowerState extends State<PriceShower> with WidgetsBindingObserver {
  final db = FirebaseFirestore.instance;

  String username = "User";

  List<Map<String, dynamic>> expenseData = [];

  double budget = -1;

  int index = -1;

  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final userRef =
        db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

    userRef.get().then((DocumentSnapshot docSnap) {
      final docData = docSnap.data() as Map<String, dynamic>;

      index = docSnap['indexList'];

      setState(() {
        debugPrint("calling setState code foor username and budget");
        username = docData['name'].toString();
        budget = docData['budget'];
      });

      if (index > 0) {
        debugPrint("calling index>0 code");
        userRef
            .collection('/monthlyExpenses')
            .where('indexNum', isEqualTo: index)
            .get()
            .then((QuerySnapshot querySnapshot) {
          final docData = querySnapshot.docs[0].data() as Map<String, dynamic>;

          debugPrint(
              "The docdata monthly expense is ${docData['monthlyExpense']}");

          setState(() {
            monthlyExpenditureValue.value = docData['monthlyExpense'];
          });
        }).onError((error, stackTrace) {
          debugPrint("Error: $error");
        });
      } else {
        setState(() {
          monthlyExpenditureValue.value = 0;
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
      // making a call to the database when we resume app to update monthly expenses and the like

      final userRef =
          db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

      userRef.get().then((DocumentSnapshot docSnap) {
        final docData = docSnap.data() as Map<String, dynamic>;

        index = docData['indexList'];
        userRef
            .collection('/monthlyExpenses')
            .where('indexNum', isEqualTo: index)
            .get()
            .then((QuerySnapshot querySnap) {
          debugPrint("Query size is ${querySnap.size}");
          final existingData = querySnap.docs[0].data() as Map<String, dynamic>;
          debugPrint(existingData['month']);
          monthlyExpenditureValue.value =
              existingData['monthlyExpense'].toDouble();

          setState(() {});
        });
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(15, 33, 61, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hi $username!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Icon(Icons.logout,
                          color: Color.fromARGB(255, 255, 255, 255), size: 30),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Stack(fit: StackFit.expand, children: [
                      CircularProgressIndicator(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          backgroundColor: Color.fromARGB(255, 255, 227, 86),
                          //value: 0.15,
                          value: 1 - (monthlyExpenditureValue.value / budget),
                          strokeWidth: 10),
                      Center(
                          child: Container(
                              height: 80,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("₹ ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold)),
                                        ValueListenableBuilder(
                                            valueListenable:
                                                monthlyExpenditureValue,
                                            builder: ((context, value, child) {
                                              return Text(
                                                  monthlyExpenditureValue.value
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold));
                                            }))
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Text("Monthly Expenditure",
                                        style: TextStyle(color: Colors.grey)),
                                  )
                                ],
                              )))
                    ]),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Budget - ₹ ",
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                      Text(budget.toStringAsFixed(0),
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
