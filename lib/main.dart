import 'package:flutter/material.dart';

import './question.dart';
import './CustomForm.dart';
import './DataInput.dart';
import './scanner.dart';
import './Buttons.dart';
import 'dart:io';
import './loggedinprostitute.dart';
import './loading_screen.dart';

void main() {
  runApp(MyApp());
}

// dynamically changes by input, is our container for all states
class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

// is a state, kind of static, contains the widgets
class _MyAppState extends State<MyApp> {

  void dd() {
    // for different input, calls build method and rebuilds the widget tree
    setState(() {
      var nextPage = 0;
    });
    print('Button pressed');
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 195, 193, 1),

        ),

      home: Scaffold(
        appBar: AppBar(
          title: Text('IOTA HEALTH',
            style: TextStyle(
                color: Colors.white,
            letterSpacing: 5,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFFAFAFA),
                //Color(0xFFE1BEE7),
                Color(0xFFD7CCC8)
              ],

            ),
          ),
        child: Column(
          children: <Widget>[


            ButtonTest(),

          ],
        ),
        ),
      ),
    );
  }
}

class ButtonTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Form(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 190, bottom: 0),
          ),
          CustomButton(
            onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Scanner()),
          );},
            buttonText: "Qr code scannen",
            icon: Icons.qr_code_2_outlined,
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
          ),
          CustomButton(
            onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataInput()),
            );},
            buttonText: "Anmeldung für Benutzer",
            icon: Icons.account_circle_outlined,
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
          ),
          CustomButton(
            onPressed: () => onLoading(context),
            buttonText: "LogIn Behörde/Arzt",
            icon: Icons.house_outlined,
          ),
        ],
      )
      );
  }


}

