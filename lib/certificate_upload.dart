import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:iota_app/CustomForm.dart';
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
  String name = "";
  String address = "";
  String birthday = "";
  String birthplace = "";

  bool dataArrived = false;
  String success = "";
  TextEditingController controller = TextEditingController();

  _CertificateUploadState({required this.roomId});

  @override
  void initState() {

    _joinServer();
    //TODO: if joinserver not successful
    _sendRequestData();

    _channel.stream.forEach((element) {

      if(element.startsWith("{"))  {
        setState(() {
          name = jsonDecode(element)['name'];
          address = jsonDecode(element)['address'];
          birthday = jsonDecode(element)['birthday'];
          birthplace = jsonDecode(element)['birthplace'];

          dataArrived = true;
        });

        _channel.sink.add("Empfangen");
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

              Text("Name: " + name),
              Text("Addresse: " + address),
              Text("Geburtstag: " + birthday),
              Text("Geburtsort: " + birthplace),
              if(dataArrived)
              CustomButton(onPressed: () => getResponse(), buttonText: "Zertifikat hochladen", icon: Icons.check),
              Text(success),
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

  void _sendRequestData() {
    _channel.sink.add("RequestData");
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Future<http.Response> createAlbum(String password, String name, String address, String birthday, String birthplace) {
    Map json = {'password': password,
      'name': name,
      'address': address,
      'birthday': birthday,
      'birthplace': birthplace};
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
  void getResponse() async {



    /*if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        success = response.body;
      });*/
      showDialog(context: context, builder: (context) {

        return StatefulBuilder(builder: (context, setState) {
          bool passwordIncorrect = false;
          return Dialog(
            backgroundColor: Colors.transparent,
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
                              passwordIncorrect = false;
                              response = await createAlbum(controller.text, name, address, birthday, birthplace);

                              if(response.statusCode == 200) {
                                print(response.body);
                              }
                              else {
                                print("Upload failed");
                              }

                          //then createAlbum
                          }
                          else {
                          print("Response failed");
                          }

                          },
                    buttonText: "Mit Passwort bestätigen",
                    icon: Icons.check),
                  passwordIncorrect ?
                  Text("Passwort falsch, erneut eingeben",
                    style: TextStyle(color: Colors.red),) : Text("")
              ],
            ),
          );
        }
        );
      }
      );

    }

    //send password and then data
    /*void sendCertificate() async {
        var response = await sendPassword(controller.text);

        if(response.statusCode == 200) {
          print(response.body);
          passwordIncorrect = false;
          build(context);
          //then createAlbum
        }
        else {
          setState(() {
            passwordIncorrect = true;
          });
          build(context);
          print(response.statusCode);
        }

    }*/


}