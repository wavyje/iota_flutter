import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './crypto.dart';




// page for the office to upload the registration certificate
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
  String firstName = "";
  String lastName = "";
  String birthday = "";
  String birthplace = "";
  String nationality = "";
  String address = "";
  String hashedImage = "";
  String expireDate = "";

  bool dataArrived = false;
  bool loading = false;
  bool success = false;
  TextEditingController controller = TextEditingController();

  _CertificateUploadState({required this.roomId});

  // listens to the websocket stream, only receives the prostitute's data
  @override
  void initState() {

    _joinServer();
    //TODO: if joinserver not successful
    _sendRequestData();

    _channel.stream.forEach((element) {
      if(element.startsWith("{")) {
        setState(() {
          firstName = jsonDecode(element)['firstName'];
          lastName = jsonDecode(element)['lastName'];
          address = jsonDecode(element)['address'];
          birthday = jsonDecode(element)['birthday'];
          birthplace = jsonDecode(element)['birthplace'];
          nationality = jsonDecode(element)['nationality'];
          hashedImage = jsonDecode(element)['hashedImage'];

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
          child: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              Text("Vorname: " + firstName, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Nachname: " + lastName, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Geburtstag: " + birthday, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Geburtsort: " + birthplace, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Staatsangehörigkeit: " + nationality, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Addresse: " + address, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              if(dataArrived && !success)
              CustomButton(onPressed: () { getResponse(); },
                  buttonText: "Zertifikat hochladen", icon: Icons.check),
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
      ),
    );
  }

  // join the websocket server with the id transferred by the qr-code
  void _joinServer() {
     _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.202:8080/' + roomId),
    );
  }

  // requests the prostitute's data
  void _sendRequestData() {
    _channel.sink.add("RequestData");
  }

  // closes the stream
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  // gathers the prostitute's information in a json and sends it via a post request to the server
  Future<http.Response> createAlbum(String password, String firstName, String lastName, String birthday, String birthplace, String nationality, String address, String hashedImage) {

    String expireDate = expire();

    Map json = {'password': password,
                'firstName': firstName,
                'lastName': lastName,
                'birthday': birthday,
                'birthplace': birthplace,
                'nationality': nationality,
                'address': address,
                'hashedImage': hashedImage,
                'expire': expireDate};
    print(json);
    return http.post(

      Uri.parse('http://192.168.0.202:8080/certificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  // sends the password so the author instance on the server can be imported
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

        return SingleChildScrollView(
          child: Dialog(
            backgroundColor: Colors.white,
            elevation: 0,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(decoration: const InputDecoration(
                    labelText: 'Passwort',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.black,
                    focusColor: Colors.black
                ),
                  cursorColor: Colors.black,
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
                          var response = await sendPassword(await generateHash(controller.text));

                          if(response.statusCode == 200) {
                            print(response.body);

                            Navigator.of(context).pop("true");

                              response = await createAlbum(await generateHash(controller.text), firstName, lastName, birthday, birthplace, nationality, address, hashedImage);

                              if(response.statusCode == 200) {

                                Map links = jsonDecode(response.body);
                                links['expireDate'] = expireDate;

                                var linksjson = jsonEncode(links);
                                print(linksjson);
                                 _channel.sink.add(linksjson);
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
          )
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

    // calculates expiration date for the certificate
    String expire() {
      DateTime rn = DateTime.now();
      print(rn);
      DateTime expire = rn.add(new Duration(days: 365));
      final df = new DateFormat('dd-MM-yyyy');
      final expireFormat =  df.format(expire);
      expireDate = expireFormat;
      return expireFormat;
    }
}