// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

/* Expense Item Widget */

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({super.key});

  @override
  State<ExpenseItem> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      Text("Food King", style: TextStyle(fontSize: 17)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Text("Food",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      )
                    ],
                  ),
                )
              ],
            )),
            Container(
                child: Text("R 75",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5)))
          ],
        ),
      )),
    );
  }
}

/* Recent Expenses Widget */

class RecentExpenses extends StatefulWidget {
  const RecentExpenses({super.key});

  @override
  State<RecentExpenses> createState() => _RecentExpensesState();
}

class _RecentExpensesState extends State<RecentExpenses> {
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
              ExpenseItem(),
              ExpenseItem(),
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
