import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'price_shower.dart';

final db = FirebaseFirestore.instance;
double? monthlyExpenditure;

class SmsModule extends StatefulWidget {
  const SmsModule({super.key});

  @override
  State<SmsModule> createState() => _SmsModuleState();
}

class _SmsModuleState extends State<SmsModule> {
  late String _message;
  final telephony = Telephony.instance;
  final db = FirebaseFirestore.instance;
  final priceInstance = PriceShower();

  onMessage(SmsMessage message) async {
    print("on message called");
    List details = getDetails(message.body ?? "Error");
    String bank, date, upi_id, reference_number, amount, category_payment;

    bank = details[0];
    date = details[1];
    upi_id = details[2];
    reference_number = details[3];
    amount = details[4];
    category_payment = details[5];

    double dAmount = double.parse(amount);

    // Firebase database update code
    final transactionData = <String, dynamic>{
      'timeOfPayment': DateTime.now().millisecondsSinceEpoch,
      'bank': bank,
      'date': date,
      'upiId': upi_id,
      'refNum': reference_number,
      'amountPaid': dAmount,
      'paymentCategory': category_payment
    };

    double? currentAmount;

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('/expenseList')
        .doc()
        .set(transactionData)
        .then((value) => print("transaction data pushed"))
        .onError((error, stackTrace) => print("Error: $error"));

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      final existingData = snapshot.data() as Map<String, dynamic>;

      double currentWeeklyAmount =
          existingData['weeklyExpenses'].toDouble() + dAmount;
      double currentMonthlyAmount =
          existingData['monthlyExpenses'].toDouble() + dAmount;

      db
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({
        'weeklyExpenses': currentWeeklyAmount,
        'monthlyExpenses': currentMonthlyAmount
      }).then((value) => print("updated new amount"));
    });
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      print("if true");
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    } else {
      print("if  false");
    }

    if (!mounted) return;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  //   print("State initialized");
  // }

  @override
  Widget build(BuildContext context) {
    initPlatformState();

    //print("inside widget build");
    // return Center(
    //   child: ElevatedButton(
    //     onPressed: () {
    //       initPlatformState();
    //     },
    //     child: const Text('Show SnackBar'),
    //   ),
    // );
    return SizedBox.shrink();
  }
}

onBackgroundMessage(SmsMessage message) async {
  await Firebase.initializeApp();

  debugPrint("onBackgroundMessage called");
  List details = getDetails(message.body ?? "Error");
  String bank, date, upi_id, reference_number, amount, category_payment;
  bank = details[0];
  date = details[1];
  upi_id = details[2];
  reference_number = details[3];
  amount = details[4];
  category_payment = details[5];

  double dAmount = double.parse(amount);

  // Firebase database update code
  final transactionData = <String, dynamic>{
    'timeOfPayment': DateTime.now().millisecondsSinceEpoch,
    'bank': bank,
    'date': date,
    'upiId': upi_id,
    'refNum': reference_number,
    'amountPaid': dAmount,
    'paymentCategory': category_payment
  };

  db
      .collection('/users')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('/expenseList')
      .doc()
      .set(transactionData)
      .then((value) => print("transaction data pushed"))
      .onError((error, stackTrace) => print("Error: $error"));

  db
      .collection('/users')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .get()
      .then((DocumentSnapshot snapshot) {
    final existingData = snapshot.data() as Map<String, dynamic>;

    double currentWeeklyAmount =
        existingData['weeklyExpenses'].toDouble() + dAmount;
    double currentMonthlyAmount =
        existingData['monthlyExpenses'].toDouble() + dAmount;

    db
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .update({
      'weeklyExpenses': currentWeeklyAmount,
      'monthlyExpenses': currentMonthlyAmount
    }).then((value) => print("updated new amount"));
  });
}

List getDetails(String body) {
  RegExp regex1 = RegExp(r'HDFC|ICICI|SBI');
  RegExpMatch? match = regex1.firstMatch(body);
  String? bank = match?.group(0);
  String? date;
  String? upi_id;
  String? reference_number;
  String? amount;
  String? category_payment;

  if (bank == "HDFC") {
    RegExp regex2 = RegExp(r'[0-3][0-9]-[0-1][1-9]-[2-9][2-9]');
    RegExpMatch? text1 = regex2.firstMatch(body);
    date = text1?.group(0);

    RegExp regex3 = RegExp(r'[a-zA-Z0-9\._-]*@[a-z]*');
    RegExpMatch? text2 = regex3.firstMatch(body);
    upi_id = text2?.group(0);

    RegExp regex4 = RegExp(r'UPI Ref No [0-9]*');
    RegExpMatch? text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)?.split(" ").elementAt(3);

    RegExp regex5 = RegExp(r'Rs [0-9]*.[0-9][0-9]');
    RegExpMatch? text4 = regex5.firstMatch(body);
    amount = text4?.group(0)?.split(" ").elementAt(1);

    RegExp regex6 = RegExp(r'credited|debited');
    RegExpMatch? text5 = regex6.firstMatch(body);
    category_payment = text5?.group(0);
  } else if (bank == "SBI") {
    RegExp regex2 = RegExp(r'[0-3][0-9][A-Z][a-z]*[2-9][2-9]');
    RegExpMatch? text1 = regex2.firstMatch(body);
    date = text1?.group(0);

    RegExp regex3 = RegExp(r'[a-zA-Z0-9\._-]*@[a-z]*|[A-Z]* [A-Z]* [A-Z]*');
    Iterable<RegExpMatch> text2 = regex3.allMatches(body);

    int flag = 0;
    String match;

    Iterable<Match> matches = regex3.allMatches(body, 0);
    for (final Match m in matches) {
      match = m[0]!;
      if (match.contains('@') == true) {
        flag = 1;
        break;
      }
    }

    if (flag == 1) {
      upi_id = matches.elementAt(0)[0]!;
    } else {
      upi_id = matches.elementAt(1)[0]!;
    }

    RegExp regex4 = RegExp(r'Ref No [0-9]*');
    RegExpMatch? text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)?.split(" ").elementAt(2);

    RegExp regex5 = RegExp(r'Rs[0-9]*.[0-9]*');
    RegExpMatch? text4 = regex5.firstMatch(body);
    amount = text4?.group(0)?.split("Rs").elementAt(1);

    RegExp regex6 = RegExp(r'credited|debited');
    RegExpMatch? text5 = regex6.firstMatch(body);
    category_payment = text5?.group(0);
  } else if (bank == "ICICI") {
    RegExp regex2 = RegExp(r'[0-3][0-9][-][A-Za-z]*[-][2-9][2-9]');
    RegExpMatch? text1 = regex2.firstMatch(body);
    //print(text1);
    date = text1?.group(0);

    RegExp regex3 = RegExp(r'[a-zA-Z0-9\._-]*@[a-z]*|[A-Z]* [A-Z]* [A-Z]*');
    Iterable<RegExpMatch> text2 = regex3.allMatches(body);

    int flag = 0;
    String match;

    Iterable<Match> matches = regex3.allMatches(body, 0);
    for (final Match m in matches) {
      match = m[0]!;
      //print(match);
      if (match.contains('@') == true) {
        upi_id = match;
        flag = 1;
        break;
      }
    }

    if (flag == 0) {
      upi_id = matches.elementAt(0)[0]!;
    }

    RegExp regex4 = RegExp(r'UPI:[0-9]*');
    RegExpMatch? text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)!.split(":").elementAt(1);

    RegExp regex5 = RegExp(r'[0-9]*[.][0-9]*');
    RegExpMatch? text4 = regex5.firstMatch(body);
    amount = text4?.group(0);

    RegExp regex6 = RegExp(r'credited|debited');
    RegExpMatch? text5 = regex6.firstMatch(body);
    category_payment = text5?.group(0);
  }
  print("check");
  // print(bank! +
  //     upi_id! +
  //     date! +
  //     " " +
  //     reference_number! +
  //     "   " +
  //     amount! +
  //     " " +
  //     category_payment!);

  //print(bank! + "lol");
  return [bank, date, upi_id, reference_number, amount, category_payment];
}
