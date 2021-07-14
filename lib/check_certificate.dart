import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:iota_app/CustomForm.dart';
import 'package:iota_app/loading_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';





class CertificateUpload extends StatefulWidget {
  final String roomId;
  CertificateUpload({required Key key, required this.roomId});

  @override
  _CertificateUploadState createState() {
    return _CertificateUploadState(roomId: roomId);
  }
}

class _CertificateUploadState extends State<CertificateUpload> {
  final String roomId;
  var _channel;
  String hashLeafAB = "";
  String expire = "";
  String birthdate = "";
  String hashLeaveD1D2 = "";
  String rootHash = "";

  bool dataArrived = false;
  bool loading = false;
  bool success = false;
  TextEditingController controller = TextEditingController();

  _CertificateUploadState({required this.roomId});

  @override
  void initState() {

    _joinServer();
    //TODO: if joinserver not successful
    _sendRequestCertificate();

    _channel.stream.forEach((element) {
      if(element.contains('appInst')) {
        setState(() {
          birthdate = element['birthdate'];
          expire = element['expireDate'];
          hashLeafAB = element['hashLeafAB'];
          hashLeaveD1D2 = element['hashLeafD1D2'];

          dataArrived = true;
        });

        _channel.sink.add("Empfangen");
        setState(() {
          loading = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Zertifikate',
            style: TextStyle(color: Colors.white, letterSpacing: 5),
          ),
          centerTitle: true,
        ),
        body: Container(
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
              Text(roomId),

              Text("Vorname: " + birthdate, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Nachname: " + expire, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Netzwerk wird durchsucht, bitte warten..."),
              Row(
                children: [
                  Text("Anmeldebescheinigung:    "),
                  if(loading)
                    CircleAvatar(backgroundImage: Image
                        .asset('assets/images/IOTA_Spawn.gif')
                        .image,
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                  if(success)
                    CircleAvatar(backgroundImage: Image
                        .asset('assets/images/check.png')
                        .image,
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              if(loading)
                CircleAvatar(backgroundImage: Image
                    .asset('assets/images/IOTA_Spawn.gif')
                    .image,
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),
              if(success)
                CircleAvatar(backgroundImage: Image
                    .asset('assets/images/check.png')
                    .image,
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
        ),
      ),
    );
  }


  void _joinServer() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.202:8080/' + roomId),
    );
  }

  void _sendRequestCertificate() {
    _channel.sink.add("RequestCertificate");
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Future<http.Response> createAlbum(String rootHash) {

    Map json = {'rootHash': rootHash};
    print(json);
    return http.post(

      Uri.parse('http://192.168.0.202:8080/certificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  Future<http.Response> sendPassword(data) {
    Map json = {'password': data};
    return http.post(
      Uri.parse('http://192.168.0.202:8080/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  //sends password to server, if okay, send data
  Future getResponse() async {

    String result = await showDialog(context: context, builder: (BuildContext context) {

      return Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(decoration: const InputDecoration(
                labelText: 'Passwort',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                focusColor: Colors.white
            ),
              cursorColor: Colors.white,
              controller: controller,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 0, top: 10, right: 0, bottom: 0),
            ),
            CustomButton(onPressed: () async {
              var response = await sendPassword(controller.text);

              if(response.statusCode == 200) {
                print(response.body);

                Navigator.of(context).pop("true");

                response = await createAlbum(rootHash);

                if(response.statusCode == 200) {
                  //print(response.body);

                  //print(links);



                  _channel.sink.close();

                }
                else {
                  Navigator.of(context).pop("error");
                }

                //then createAlbum
              }
              else {
                print("Response failed");
                Navigator.of(context).pop("password");
              }

            },
                buttonText: "Mit Passwort bestätigen",
                icon: Icons.check),
          ],
        ),
      );
    }
    );

    if(result == "true") {
      setState(() {
        loading = false;
        success = true;
      });
    }
    else if(result == "error") {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(content: Text("Upload fehlgeschlagen, erneut versuchen"));
      });
    }
    else if(result == "password") {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(content: Text("Passwort falsch, erneut versuchen"));
      });
    }

  }

}