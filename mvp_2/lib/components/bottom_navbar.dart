// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

int selectedIndex = 0;

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      color: Color.fromRGBO(15, 33, 61, 1),
      child: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: selectedIndex,
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
    );
  }
}
