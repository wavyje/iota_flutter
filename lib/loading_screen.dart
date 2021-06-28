import 'package:flutter/material.dart';


void onLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(backgroundImage: Image.asset('assets/images/IOTA_Spawn.gif').image,
              radius: 100,

            ),
            Container(
              margin: EdgeInsets.only(left:0, top:10, right:0, bottom:0),
            ),
            new Text("Loading", style:
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              fontSize: 20,
            ),
            ),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 4), () {
    Navigator.pop(context); //pop dialog
  });
}