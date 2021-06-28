import 'package:flutter/material.dart';

import './CustomForm.dart';

class DataInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registrieren'),
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