import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import './Buttons.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() {
    return _QrPageState();
  }
}

class _QrPageState extends State<QrPage> {

  String _imagePath = "";

  @override
  void initState() {
    super.initState();
    _loadImage();
  }
  // for different input, calls build method and rebuilds the widget tree

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
              AppBar(title: Text("IOTA HEALTH",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
                elevation: 25,
                centerTitle: true,
                toolbarOpacity: 0.8,
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 0),
              ),
              CircleAvatar(backgroundImage: FileImage(File(_imagePath),
              ),
                radius: 115,
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 0),
              ),
              QrImage(
                data: 'https://wikipedia.com',
                version: QrVersions.auto,
                size: 240,
                gapless: false,
              ),

              Container(
                margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
              ),
              CustomButton(onPressed: () => null,
                  buttonText: "Abbrechen",
                  icon: Icons.cancel)
            ]

        ),
      ),
    );
  }

  void _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = (prefs.getString('profile_image') ?? "Not Found");
    });
  }
}