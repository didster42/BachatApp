import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

final Telephony telephony = Telephony.instance;

List getDetails (String body) {
  final regex1 = RegExp(r'HDFC|ICICI|SBI');
  final match = regex1.firstMatch(body);
  final bank = match?.group(0);
  String? date;
  String? upi_id;
  String? reference_number;
  String? amount;
  String? category_payment;

  if (bank == "HDFC") {
    final regex2 = RegExp(r'[0-3][0-9]-[0-1][1-9]-[2-9][2-9]');
    final text1 = regex2.firstMatch(body);
    date = text1?.group(0);

    final regex3 = RegExp(r'[a-zA-Z0-9\._-]*@[a-z]*');
    final text2 = regex3.firstMatch(body);
    upi_id = text2?.group(0);

    final regex4 = RegExp(r'UPI Ref No [0-9]*');
    final text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)?.split(" ").elementAt(3);

    final regex5 = RegExp(r'Rs [0-9]*.[0-9][0-9]');
    final text4 = regex4.firstMatch(body);
    amount = text4?.group(0)?.split(" ").elementAt(1);

    final regex6 = RegExp(r'credited|debited');
    final text5 = regex4.firstMatch(body);
    category_payment = text5?.group(0);
  }

  else if (bank == "SBI") {
    final regex2 = RegExp(r'[0-3][0-9][A-Z][a-z]*[2-9][2-9]');
    final text1 = regex2.firstMatch(body);
    date = text1?.group(0);

    final regex3 = RegExp(r'[a-zA-Z0-9\._-]*@[a-z]*|[A-Z]* [A-Z]* [A-Z]*');
    final text2 = regex3.allMatches(body);

    int flag = 0;
    String match;

    Iterable<Match> matches = regex3.allMatches(body, 0);
    for (final Match m in matches) {
      match = m[0]!;
      if (match.contains('@') == true) {
        flag == 1;
        break;
      }
    }

    if (flag == 1) {
      upi_id = matches.elementAt(0)[0]!;
    }

    else {
      upi_id = matches.elementAt(1)[0]!;
    }

    final regex4 = RegExp(r'Ref No [0-9]*');
    final text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)?.split(" ").elementAt(2);

    final regex5 = RegExp(r'Rs[0-9]*.[0-9]*');
    final text4 = regex4.firstMatch(body);
    amount = text4?.group(0)?.split("Rs").elementAt(1);

    final regex6 = RegExp(r'credited|debited');
    final text5 = regex4.firstMatch(body);
    category_payment = text5?.group(0);
  }

  else if (bank == "ICICI") {
    final regex2 = RegExp(r'[0-3][0-9][A-Z][a-z]*[2-9][2-9]');
    final text1 = regex2.firstMatch(body);
    final date = text1?.group(0);

    final regex3 = RegExp(r'[a-zA-Z0-9\._-]*@[a-z]*|[A-Z]* [A-Z]* [A-Z]*');
    final text2 = regex3.allMatches(body);

    int flag = 0;
    String match;

    Iterable<Match> matches = regex3.allMatches(body, 0);
    for (final Match m in matches) {
      match = m[0]!;
      if (match.contains('@') == true) {
        flag == 1;
        break;
      }
    }

    if (flag == 1) {
      upi_id = matches.elementAt(0)[0]!;
    }

    else {
      upi_id = matches.elementAt(1)[0]!;
    }

    final regex4 = RegExp(r'Ref No [0-9]*');
    final text3 = regex4.firstMatch(body);
    reference_number = text3?.group(0)?.split(" ").elementAt(2);

    final regex5 = RegExp(r'Rs[0-9]*.[0-9]*');
    final text4 = regex4.firstMatch(body);
    amount = text4?.group(0)?.split("Rs").elementAt(1);

    final regex6 = RegExp(r'credited|debited');
    final text5 = regex4.firstMatch(body);
    category_payment = text5?.group(0);
  }

  return [bank, date, upi_id, reference_number, amount, category_payment];

}

backgroundMessageHandler(SmsMessage message) async {
  //Handle background message
  String address = message.address!;
  String body = message.body!;

  // Extract details
  List details = getDetails(body);
  String? bank, date, upi_id, reference_number, amount, category_payment;
  bank = details[0];
  date = details[1];
  upi_id = details[2];
  reference_number = details[3];
  amount = details[4];
  category_payment = details[5];

  // Verify if details are extracted correctly
  print("background mei aaya");

  // Feed into Firebase



  // Do Processing


}

void main() {

  test ()async {
  print('test');
    List<SmsConversation> messages = await telephony.getConversations(
        filter: ConversationFilter.where(ConversationColumn.MSG_COUNT)
            .equals("1")
            .and(ConversationColumn.THREAD_ID)
            .greaterThan("12"),
        sortOrder: [OrderBy(ConversationColumn.THREAD_ID, sort: Sort.ASC)]
    );
    print(messages);
  //   await telephony.listenIncomingSms(
  //     onNewMessage: (SmsMessage message) {
  //       // Handle message
  //       print("foreground");
  //       print(message.body);
  //     },
  //     onBackgroundMessage: backgroundMessageHandler
  // );
  }
  runApp(MaterialApp(

    home : Scaffold(
      appBar : AppBar(
        title : Text('My First App'),
        backgroundColor: Colors.deepPurple[400],
        centerTitle: true,
      ),
      body: Column(children:[Center(
        child : Text('hello darling'),
      ),InkWell(
        onTap: ()=>test(),
        child: Container(height: 100, width: 100,color: Colors.red,)
      ),]),
      floatingActionButton: FloatingActionButton(
          onPressed: () =>test(),
        backgroundColor: Colors.deepPurple[400],
        child : Text('CLICK'),
      ),
    ),



  ));
}

