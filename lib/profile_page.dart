import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iota_app/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import './Buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {

  String _imagePath = "";
  String _lastName = "";
  String _firstName = "";
  String _birthday = "";
  String _birthplace = "";
  String _address = "";

  bool showLoading = false;

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
      child: Container(
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

          IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
              child: Text(AppLocalizations.of(context)!.firstName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
              child: Text(AppLocalizations.of(context)!.lastName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
              child: Text(AppLocalizations.of(context)!.birthday,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
              child: Text(AppLocalizations.of(context)!.birthplace,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              ),
                  Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                    child: Text(AppLocalizations.of(context)!.address,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
        ],
      ),
                 Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                 child: const VerticalDivider(color: Colors.black, thickness: 2, width: 20,),
                 ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                  child: Text(_firstName,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                  child: Text(_lastName,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                  child: Text(_birthday),
                ),
                Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                  child: Text(_birthplace),
                ),
                Padding(padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                  child: Text(_address),
                ),
              ],

            ),
          ]
          ),

          ),
          Container(
            margin: EdgeInsets.only(left:0, top:70, right:0, bottom:0),
          ),
          CustomButton(onPressed: () {
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  clipBehavior: Clip
                      .antiAlias,
                  children: <
                Widget>[
                Positioned(
                right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator
                          .of(
                          context)
                          .pop();
                    },
                    child: CircleAvatar(
                      child: Icon(
                          Icons
                              .close),
                      backgroundColor: Colors
                          .red,
                    ),
                  ),
                ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Do you really want to delete your data?", textAlign: TextAlign.center,),
                        Container(padding: EdgeInsets.all(10),),
                        Text("Doing so will erase everything from your phone and therefore invalidate your certificates!", textAlign: TextAlign.center,),
                        Container(padding: EdgeInsets.all(10),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(onPressed: () async {
                              _deleteImage();
                              _deleteData();
                              _deleteLinks();
                              _deleteCertificateDates();

                              Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                            }, buttonText: "Confirm", icon: Icons.warning_amber_outlined),
                            Container(padding: EdgeInsets.all(10),),
                            CustomButton(onPressed: () {
                              Navigator.pop(context);
                            }, buttonText: "Cancel", icon: Icons.cancel),
                          ],
                        )

                      ],
                    )
                ]
                )
              );
            });
          }, buttonText: AppLocalizations.of(context)!.deleteDataButton, icon: Icons.cancel)
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

  void _deleteImage() async {
    File file = await _imageFile;

    file.delete();

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  void _loadData() async {
    final file = await _localFile;

    //Read the file
    final contents = await file.readAsString();
    final Map<String, dynamic> json = jsonDecode(contents);

    setState(() {
      _firstName = json['firstName'];
      _lastName = json['lastName'];
      _address = json['address'];
      _birthday = json['birthday'];
      _birthplace = json['birthplace'];
    });
  }

  void _deleteData() async {
    final file = await _localFile;

    file.delete();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> get _imageFile async  {
    final path = await _localPath;
    return File('$path/image');
  }

  Future<File> get _localLinkFile async {
    final path = await _localPath;
    return File('$path/links.txt');
  }

  Future<File> get _localCertificateFile async {
    final path = await _localPath;
    return File('$path/certificate.txt');
  }

  void _deleteLinks() async {
    final file = await _localLinkFile;

    file.delete();
  }
  void _deleteCertificateDates() async {
    final file = await _localCertificateFile;

    file.delete();
  }
}