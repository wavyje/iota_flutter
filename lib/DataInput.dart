import 'package:flutter/material.dart';

import './CustomForm.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// page for the registration
class DataInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:
        new ListView(
        children: <Widget>[ Container(
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
          ]
      ),
      );
  }
}