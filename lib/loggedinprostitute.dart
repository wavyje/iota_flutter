import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './imagePicker.dart';
import './Buttons.dart';
import './profile_page.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() {
    return _UserMenuState();
  }
}

class _UserMenuState extends State<UserMenu> {

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
          Container(
            margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
          ),
          CustomButton(onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );},
              buttonText: "Persönliche Daten", icon: Icons.account_circle_outlined),
          Container(
            margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
          ),
          CustomButton(onPressed: () => null, buttonText: "Zertifikate", icon: Icons.badge_outlined),
          Container(
            margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
          ),
          CustomButton(onPressed: () => null, buttonText: "Qr Code erstellen", icon: Icons.qr_code_2_outlined),
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

