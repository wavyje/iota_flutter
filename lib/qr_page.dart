import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iota_app/loading_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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
  var _channel;
  String _imagePath = "";
  String _json = "";

  @override
  void initState(){
    _loadData();
    _loadImage();
    _joinServer();
    //streamController.addStream(_channel.stream);


    print("Creating a StreamController...");
    //First subscription
    /*StreamSubscription sub = streamController.stream.listen((data) {
      print("DataReceived1: " + data);
      if(data == "RequestData") {
        streamController.add(_json);
      }
      }, onDone: () {
      print("Task Done1");
    }, onError: (error) {
      print("Some Error1");
    });*/

    _channel.stream.forEach((element) {
      print(element);
      if(element == "RequestData")  {
        _channel.sink.add(_json);

        Future.delayed(new Duration(seconds: 0), () {
          onLoading(context);
        });
      }

    });

    super.initState();
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
                //ws://192.168.0.202:8080/cdab716e-5269-4b86-b770-bba772be4962
                data: 'UploadCertificate/cdab716e-5269-4b86-b770-bba772be4962',
                version: QrVersions.auto,
                size: 240,
                gapless: false,
              ),

              Container(
                margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
              ),
              CustomButton(onPressed: () { Navigator.pop(
                context,
              );},
                  buttonText: "Abbrechen",
                  icon: Icons.cancel),

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

  void _joinServer() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.202:8080/cdab716e-5269-4b86-b770-bba772be4962'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void _loadData() async {
    final file = await _localFile;

    //Read the file
    final contents = await file.readAsString();
    //final Map<String, dynamic> json = jsonDecode(contents);

    _json = contents;
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
