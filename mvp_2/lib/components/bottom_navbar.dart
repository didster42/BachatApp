// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Color.fromRGBO(15, 33, 61, 1),
      child: BottomNavigationBar(
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Rewards")
          ],
          elevation: 0,
          iconSize: 30,
          backgroundColor: Color.fromRGBO(15, 33, 61, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey),
    );
  }
}
