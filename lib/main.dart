import 'package:flutter/material.dart';

import './question.dart';
import './CustomForm.dart';
import './DataInput.dart';
import './scanner.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: Text('IOTA HEALTH'),
        ),
        body: Column(
          children: <Widget>[

            Text('Sie möchten sich registrieren oder anmelden?', textAlign: TextAlign.center,),
            ButtonTest(),
            ElevatedButton(
              onPressed: null,
              child: Text('Anmeldung für Behörden'),
            ),
          ],
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
          ElevatedButton(
            child: Text('Qr Code scannen'),
            onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Scanner()),
          );},
          ),
          ElevatedButton(
            child: Text('Anmeldung für Prostituierte'),
            onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataInput()),
            );},
          ),
        ],
      )
      );
  }
}

