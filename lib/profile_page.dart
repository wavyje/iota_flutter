import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import './Buttons.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {

  String _imagePath = "";
  String _name = "";
  String _address = "";
  String _birthday = "";
  String _birthplace = "";

  @override
  void initState() {
    super.initState();
    _loadImage();
    _loadData();
  }

  // for different input, calls build method and rebuilds the widget tree

  @override
  Widget build(BuildContext context) {

    return Material(
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
            margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
          ),
          CircleAvatar(backgroundImage: FileImage(File(_imagePath),
          ),
            radius: 100,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          child: Text("Vorname, Nachname:    " + _name,

          ),
          ),
          Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          child: Text("Addresse:    " + _address),
          ),
          Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          child: Text("Geburtstag:    " + _birthday),
          ),
          Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          child: Text("Geburtsort:    " + _birthplace),
          ),
        ],
      ),
    ]
    )
    );
  }


  void _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = (prefs.getString('profile_image') ?? "Not Found");
    });
  }

  void _loadData() async {
    final file = await _localFile;

    //Read the file
    final contents = await file.readAsString();
    final Map<String, dynamic> json = jsonDecode(contents);

    setState(() {
      _name = json['name'];
      _address = json['address'];
      _birthday = json['birthday'];
      _birthplace = json['birthplace'];
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }
}