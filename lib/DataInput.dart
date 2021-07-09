import 'package:flutter/material.dart';

import './CustomForm.dart';

class DataInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registrieren', style: TextStyle(color: Colors.white, letterSpacing: 5),
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
                Colors.deepPurpleAccent,
                //Color(0xFFE1BEE7),
                Colors.purpleAccent
              ],

            ),
          ),
        child: Column(
          children: <Widget>[
            MyCustomForm(),
          ],
        ),
      ),
      ),
    );
  }
}