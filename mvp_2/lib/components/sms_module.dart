import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'price_shower.dart';

final monthList = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

final db = FirebaseFirestore.instance;
double monthlyExpenditure = -1;

class SmsModule extends StatefulWidget {
  const SmsModule({super.key});

  @override
  State<SmsModule> createState() => SmsModuleState();
}

class SmsModuleState extends State<SmsModule> {
  late String _message;

  final telephony = Telephony.instance;
  final db = FirebaseFirestore.instance;

  onMessage(SmsMessage message) async {}

  void initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    if (result != null && result) {
      debugPrint("Requested Permissions");

      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    } else {
      debugPrint("Permissions Not given for Phone and SMS");
    }

    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

@pragma('vm:entry-point')
void onBackgroundMessage(SmsMessage message) async {
  await Firebase.initializeApp();

  debugPrint("onBackgroundMessage called");

  List details = getDetails(message.body ?? "Error");

  String bank, date, upiId, referenceNumber, amount, categoryPayment;

  for (int i = 0; i < details.length; i++) {
    debugPrint("item $i ${details[i]}");
  }

  bank = details[0];
  upiId = details[2];
  referenceNumber = details[3];
  amount = details[4];
  categoryPayment = details[5];

  double dAmount = double.parse(amount);

  DateTime currentTime = DateTime.now();

  final userRef =
      db.collection('/users').doc(FirebaseAuth.instance.currentUser?.email);

  // setting a default index value before I update
  int index = -1;

  // Firebase database update code
  final transactionData = <String, dynamic>{
    'timeOfPayment': currentTime.millisecondsSinceEpoch,
    'bank': bank,
    'upiId': upiId,
    'refNum': referenceNumber,
    'amountPaid': dAmount,
    'paymentCategory': categoryPayment,
    'day': currentTime.day,
  };

  // Code to get index
  userRef.get().then((DocumentSnapshot snapshot) {
    final docData = snapshot.data() as Map<String, dynamic>;

    index = docData['indexList'];

    if (index == 0) {
      userRef.update({'indexList': 1});
      final monthData = <String, dynamic>{
        'monthlyExpense': 0.0,
        'indexNum': 1,
        'month': monthList[currentTime.month - 1],
        'year': currentTime.year
      };

      userRef
          .collection('/monthlyExpenses')
          .doc(
              '${currentTime.year.toString()}_${monthList[currentTime.month - 1].toString()}')
          .set(monthData)
          .then((value) {
        index = 1;
        userRef
            .collection('/monthlyExpenses')
            .where('indexNum', isEqualTo: index)
            .get()
            .then((QuerySnapshot querySnap) {
          querySnap.docs[0].reference
              .collection('/monthExpenseDocuments')
              .doc()
              .set(transactionData)
              .then((value) => debugPrint("Transaction data has been pushed"))
              .onError((error, stackTrace) => debugPrint("Error: $error"));

          final existingData = querySnap.docs[0].data() as Map<String, dynamic>;
          double currentMonthlyAmount =
              existingData['monthlyExpense'].toDouble() + dAmount;

          querySnap.docs[0].reference
              .update({'monthlyExpense': currentMonthlyAmount}).then((value) {
            debugPrint("updated new monthly expenses amount");
            debugPrint(currentMonthlyAmount.toString());

            monthlyExpenditureValue.value = currentMonthlyAmount;
            debugPrint(monthlyExpenditureValue.value.toString());
          }).onError((error, stackTrace) {
            debugPrint("Error: $error");
          });
        });
      }).onError((error, stackTrace) {
        debugPrint("Error: $error");
      });
    } else {
      debugPrint("After else statement index value is $index");

      userRef
          .collection('/monthlyExpenses')
          .where('indexNum', isEqualTo: index)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs[0].id !=
            "${currentTime.year.toString()}_${monthList[currentTime.month - 1].toString()}") {
          // set new index and make a new document with a new ID
          index += 1;
          userRef
              .update({'indexList': index})
              .then((value) => debugPrint("IndexList index updated"))
              .onError((error, stackTrace) => debugPrint("Error: $error"));

          final monthData = <String, dynamic>{
            'monthlyExpense': transactionData['monthlyExpense'],
            'indexNum': index,
            'month': monthList[currentTime.month - 1],
            'year': currentTime.year
          };

          userRef
              .collection('/monthlyExpenses')
              .doc(
                  '${currentTime.year.toString()}_${monthList[currentTime.month - 1].toString()}')
              .set(monthData)
              .then((value) {
            debugPrint("Created a new doc and set its index data");

            userRef
                .collection('/monthlyExpenses')
                .where('indexNum', isEqualTo: index)
                .get()
                .then((QuerySnapshot querySnap) {
              querySnap.docs[0].reference
                  .collection('/monthExpenseDocuments')
                  .doc()
                  .set(transactionData)
                  .then(
                      (value) => debugPrint("Transaction data has been pushed"))
                  .onError((error, stackTrace) => debugPrint("Error: $error"));
            });
          }).onError((error, stackTrace) {
            debugPrint("error: $error");
          });
        } else {
          snapshot.docs[0].reference
              .collection('/monthExpenseDocuments')
              .doc()
              .set(transactionData)
              .then((value) => debugPrint("Transaction data has been pushed"))
              .onError((error, stackTrace) => debugPrint("Error: $error"));
        }

        final existingData = snapshot.docs[0].data() as Map<String, dynamic>;
        double currentMonthlyAmount =
            existingData['monthlyExpense'].toDouble() + dAmount;

        snapshot.docs[0].reference
            .update({'monthlyExpense': currentMonthlyAmount}).then((value) {
          debugPrint("updated new monthly expenses amount");
          debugPrint(currentMonthlyAmount.toString());

          monthlyExpenditureValue.value = currentMonthlyAmount;
          debugPrint(monthlyExpenditureValue.value.toString());
        }).onError((error, stackTrace) {
          debugPrint("Error: $error");
        });
      });
    }
  }).onError((error, stackTrace) {
    debugPrint("Error lmaobamba: $error");
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

    RegExp regex4 = RegExp(r'Refno [0-9]*');
    RegExpMatch? text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)?.split(" ").elementAt(1);

    RegExp regex5 = RegExp(r'[0-9]*\.[0-9]*');
    RegExpMatch? text4 = regex5.firstMatch(body);
    amount = text4?.group(0);

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

  return [bank, date, upi_id, reference_number, amount, category_payment];
}

typedef UpdateCallback = void Function({required double valueAfterSms});
