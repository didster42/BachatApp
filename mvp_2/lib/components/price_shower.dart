// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class PriceShower extends StatefulWidget {
  const PriceShower({super.key});

  @override
  State<PriceShower> createState() => _PriceShowerState();
}

class _PriceShowerState extends State<PriceShower> {
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
                child: Text("Hi Shaurya!",
                    style: TextStyle(
                        color: Color.fromARGB(255, 216, 216, 216),
                        fontSize: 17.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(fit: StackFit.expand, children: [
                      CircularProgressIndicator(
                          color: Color.fromARGB(230, 255, 255, 255),
                          backgroundColor: Color.fromARGB(255, 255, 239, 155),
                          value: 0.15,
                          strokeWidth: 10),
                      Center(
                          child: Container(
                              height: 80,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text("₹ 6942",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold)),
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
                  child: Text("Budget - ₹ 7500",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              )
            ],
          )),
    );
  }
}
