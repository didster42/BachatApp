import 'package:flutter/material.dart';
import 'recent_expenses.dart';

class ExpenseShower extends StatefulWidget {
  const ExpenseShower({super.key});

  @override
  State<ExpenseShower> createState() => _ExpenseShowerState();
}

class _ExpenseShowerState extends State<ExpenseShower> {
  List<Map<String, dynamic>> _currentExpenseList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentExpenseList = expenseList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Latest Expenses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(15, 33, 61, 1),
        ),
        body: Container(
            color: const Color.fromRGBO(18, 38, 70, 1),
            child: ListView.builder(
                itemCount: _currentExpenseList.length,
                itemBuilder: (context, index) {
                  return PriceShowWidget(index, _currentExpenseList);
                })));
  }
}

class PriceShowWidget extends StatelessWidget {
  //const PriceShowWidget({super.key});

  int index;
  List<Map<String, dynamic>> _currentExpenseList;

  // writing constructor to pass index
  PriceShowWidget(this.index, this._currentExpenseList);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: const Icon(
                      Icons.wallet,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      _currentExpenseList[index]['paymentTo'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ],
              ),
              Text("₹ " + _currentExpenseList[index]['amountPaid'].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
