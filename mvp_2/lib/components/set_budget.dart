import 'package:flutter/material.dart';

double budget = 3000;

class SetBudget extends StatefulWidget {
  const SetBudget({super.key});

  @override
  State<SetBudget> createState() => _SetBudgetState();
}

class _SetBudgetState extends State<SetBudget> {
  void SetBudgetValue() {
    setState(() {
      budget = budget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Budget Setter", style: TextStyle(fontSize: 25)),
            SizedBox(height: 50),
            Text(budget.toStringAsFixed(0),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Slider(
                min: 1,
                max: 15000,
                value: budget,
                activeColor: Color.fromRGBO(15, 33, 61, 1),
                onChanged: (newValue) {
                  setState(() {
                    budget = newValue;
                  });
                }),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: SetBudgetValue, child: Text("Set Budget!"))
          ],
        ));
  }
}
