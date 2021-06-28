import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './imagePicker.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() {
    return _UserMenuState();
  }
}

class _UserMenuState extends State<UserMenu> {

  String _imagePath = "";

  // for different input, calls build method and rebuilds the widget tree

  @override
  Widget build(BuildContext context) {
    _loadImage();
    return Material(
      child: Column(
        children: <Widget>[
          AppBar(title: Text("IOTA HEALTH"),
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
          Text('Home', textAlign: TextAlign.center,),
          ElevatedButton(
            onPressed: null,
            child: Text('Persönliche Daten'),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('Zertifikate'),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('Qr Code erstellen'),
          ),
        ],
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

