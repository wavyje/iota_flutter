import 'package:flutter/material.dart';

import './CustomForm.dart';

class DataInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 195, 193, 1),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registrieren', style: TextStyle(color: Colors.white,),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            MyCustomForm(),
          ],
        ),
      ),
    );
  }
}