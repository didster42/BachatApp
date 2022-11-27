import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

List getDetails (String body) {
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
  }

  else if (bank == "SBI") {

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
    }

    else {
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
  }

  else if (bank == "ICICI") {
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
  print(bank! + upi_id! + date! + " " + reference_number! + "   " + amount! + " " + category_payment!);
   //print(bank! + "lol");
  return [bank, date, upi_id, reference_number, amount, category_payment];

}

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = "";
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    List details = getDetails(message.body??"Error");
    String bank, date, upi_id, reference_number, amount, category_payment;
    bank = details[0];
    date = details[1];
    upi_id = details[2];
    reference_number = details[3];
    amount = details[4];
    category_payment = details[5];

    setState(() {

      // Extract details
      _message = "   bank :  " + bank +
                  "  upi_id : " + upi_id +
                    "  date : " + date +
                "  reference_number :  " + reference_number +
                "  amount : " + amount +
                "   category_payment :   " + category_payment;

      // _message = message.body ?? "Error reading message body.";
      // _message =    message.body?? "err";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Latest received SMS: $_message")),
          TextButton(
              onPressed: () async {
                await telephony.openDialer("123413453");
              },
              child: Text('Open Dialer'))
        ],
      ),
    ));
  }
}
