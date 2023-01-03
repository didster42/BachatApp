// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mvp_2/components/set_budget.dart';
import '../components/sms_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<double> monthlyExpenditureValue = ValueNotifier(-1);

class PriceShower extends StatefulWidget {
  const PriceShower({super.key});

  @override
  State<PriceShower> createState() => PriceShowerState();
}

class PriceShowerState extends State<PriceShower> with WidgetsBindingObserver {
  final db = FirebaseFirestore.instance;
  String username = "Shaurya";

  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      final docData = snapshot.data() as Map<String, dynamic>;

      setState(() {
        monthlyExpenditureValue.value = docData['monthlyExpenses'];
        username = docData['name'].toString();
      });
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

      db
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get()
          .then((DocumentSnapshot snapshot) {
        final existingData = snapshot.data() as Map<String, dynamic>;

        monthlyExpenditureValue.value =
            existingData['monthlyExpenses'].toDouble();
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
                            color: Color.fromARGB(255, 216, 216, 216),
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Icon(Icons.logout,
                          color: Color.fromARGB(255, 213, 213, 213), size: 30),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(fit: StackFit.expand, children: [
                      CircularProgressIndicator(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          backgroundColor: Color.fromARGB(255, 255, 239, 155),
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
