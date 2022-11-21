// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpenseAnalysis extends StatefulWidget {
  const ExpenseAnalysis({super.key});

  @override
  State<ExpenseAnalysis> createState() => _ExpenseAnalysisState();
}

class _ExpenseAnalysisState extends State<ExpenseAnalysis> {
  // Contains data for the pie chart code, later we will get this mapping right from our database
  Map<String, double> costMapping = {
    "Food": 42,
    "Subscriptions": 69,
    "Miscellaneous": 20
  };

  // List of colors for the pie chart, could try creating a colour palette generator function
  // which would add more colours as more items are added, so that it fits with whatever
  // color scheme we choose
  List<Color> costChartColors = [
    Color.fromARGB(255, 202, 91, 91),
    Color.fromRGBO(63, 81, 181, 1),
    Color.fromRGBO(0, 103, 91, 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Expense Analysis",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: PieChart(
                dataMap: costMapping,
                chartRadius: 250,
                colorList: costChartColors,
                legendOptions: LegendOptions(
                    showLegendsInRow: true,
                    legendTextStyle: TextStyle(fontSize: 10),
                    legendPosition: LegendPosition.bottom),
                chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: false,
                    chartValueStyle:
                        TextStyle(color: Colors.white, fontSize: 10))),
          )
        ],
      )),
    );
  }
}
