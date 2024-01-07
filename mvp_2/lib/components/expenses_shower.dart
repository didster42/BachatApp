import 'package:flutter/material.dart';
import 'recent_expenses.dart';
import 'package:intl/intl.dart';

class ExpenseShower extends StatefulWidget {
  const ExpenseShower({super.key});

  @override
  State<ExpenseShower> createState() => _ExpenseShowerState();
}

class _ExpenseShowerState extends State<ExpenseShower> {
  Map<int, List<Map<String, dynamic>>> _currentExpenseList = {};
  Map<int, List<dynamic>> _indexMonth = {};
  int totalLength = 0;

  @override
  void initState() {
    super.initState();

    _currentExpenseList = monthExpenseList;
    _indexMonth = indexMonth;
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
                  int _currIndex = index + 1;
                  return ExpenseWidgetContainer(
                      _currentExpenseList[_currIndex]!.length,
                      _currentExpenseList,
                      _indexMonth[_currIndex]![0],
                      _indexMonth[_currIndex]![1],
                      _currIndex);

                  //return SizedBox.shrink();
                })));
  }
}

class ExpenseWidgetContainer extends StatelessWidget {
  //const ExpenseWidgetContainer({super.key});

  int numValues, _year, _currIndex;
  String _month;
  final Map<int, List<Map<String, dynamic>>> _currentExpenseList;

  ExpenseWidgetContainer(this.numValues, this._currentExpenseList, this._month,
      this._year, this._currIndex);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          child: Row(children: [
            Text("$_month ${_year.toString()}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25))
          ]),
        ),
        ListView.builder(
            itemCount: numValues,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: ((context, index) {
              debugPrint(numValues.toString());
              return ExpenseWidget(
                  _currentExpenseList, _currIndex, index, _month, _year);
            }))
      ],
    );
  }
}

class ExpenseWidget extends StatelessWidget {
  //const ExpenseWidget({super.key});

  final Map<int, List<Map<String, dynamic>>> _currentExpenseList;
  final _expenseIndex, _currIndex, _year;
  final _month;
  ExpenseWidget(this._currentExpenseList, this._currIndex, this._expenseIndex,
      this._month, this._year);

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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Icon(
                      Icons.wallet,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentExpenseList[_currIndex]![_expenseIndex]
                                  ['paymentTo']
                              .toString()
                              .trim(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        Row(
                          children: [
                            Text(
                                "${_currentExpenseList[_currIndex]![_expenseIndex]['day']} $_month $_year",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 132, 132, 132))),
                            const SizedBox(width: 5),
                            Text(
                                DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _currentExpenseList[_currIndex]![
                                            _expenseIndex]['timeOfPayment'])),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 132, 132, 132))),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Text(
                  "₹ ${_currentExpenseList[_currIndex]![_expenseIndex]['amountPaid'].toString()}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
