// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mvp_2/components/recent_expenses.dart';
import 'package:mvp_2/components/sms_module.dart';
import '../components/bottom_navbar.dart';
import '../components/price_shower.dart';
import '../components/expense_analyse.dart';
import '../components/set_budget.dart';
//import '../components/sms_module.dart';

PriceShower? priceShowerInstance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final screens = [
    Container(
      child: ListView(
        children: [
          priceShowerInstance = PriceShower(),
          SmsModule(),
          RecentExpenses(),
          ExpenseAnalysis()
        ],
      ),
    ),
    SetBudget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
          color: Color.fromRGBO(15, 33, 61, 1),
          child: BottomNavigationBar(
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              // ignore: prefer_const_literals_to_create_immutables
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit), label: "Set Budget"),
              ],
              elevation: 0,
              iconSize: 30,
              backgroundColor: Color.fromRGBO(15, 33, 61, 1),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey),
        ),
        body: screens[_selectedIndex]);
  }
}
