// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mvp_2/components/recent_expenses.dart';
import '../components/bottom_navbar.dart';
import '../components/price_shower.dart';
import '../components/expense_analyse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavbar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [PriceShower(), RecentExpenses(), ExpenseAnalysis()],
          ),
        ));
  }
}