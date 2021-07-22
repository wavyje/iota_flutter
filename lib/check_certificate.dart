import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:iota_app/CustomForm.dart';
import 'package:iota_app/loading_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './crypto.dart';





class CertificateCheck extends StatefulWidget {
  final String roomId;
  CertificateCheck({required Key key, required this.roomId});

  @override
  _CertificateCheckState createState() {
    return _CertificateCheckState(roomId: roomId);
  }
}

class _CertificateCheckState extends State<CertificateCheck> {
  final String roomId;
  var _channel;
  String hashLeafAB = "";
  String expire = "";
  String birthdate = "";
  String hashLeafD = "";
  String rootHash = "";
  String appInst = "";
  String AnnounceMsgId = "";
  String KeyloadMsgId = "";
  String SignedMsgId = "";

  bool dataArrived = false;
  bool loading = false;
  bool success = false;
  bool notValid = false;
  TextEditingController controller = TextEditingController();

  _CertificateCheckState({required this.roomId});

  @override
  void initState() {

    _joinServer();
    //TODO: if joinserver not successful
    _sendRequestCertificate();

    _channel.stream.forEach((element) async {
      if(element.contains("appInst") && element.contains("leafAB")) {
        print(element);
        setState(() {
          birthdate = jsonDecode(element)['birthday'];
          expire = jsonDecode(element)['expireDate'];
          hashLeafAB = jsonDecode(element)['leafAB'];
          hashLeafD = jsonDecode(element)['leafD'];
          appInst = jsonDecode(element)['appInst'];
          KeyloadMsgId = jsonDecode(element)['KeyloadMsgId'];
          SignedMsgId = jsonDecode(element)['SignedMsgId'];
          AnnounceMsgId = jsonDecode(element)['AnnounceMsgId'];

          dataArrived = true;
          loading = true;
        });

        var response = await checkMessageLinks();

        print("HCECKCEKC");
        if(response.statusCode == 200) {
          setState(() {
            loading = false;
            success = true;
          });

          print("FAFSFS");
        }
        else {
          setState(() {
            notValid = true;
          });

          print("NMICHT GUT");
        }
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

              Text("Geburtstag: " + birthdate, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Gültig bis: " + expire, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text("Netzwerk wird durchsucht, bitte warten..."),
              Row(
                children: [
                  Container(margin: EdgeInsets.only(left: 20, top: 20, right: 0, bottom: 0),),
                  Text("Anmeldebescheinigung:    ", style: TextStyle(color: Colors.white),),
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
              Row(
                children: [
                  Container(margin: EdgeInsets.only(left: 20, top: 20, right: 0, bottom: 0),),
                  Text("Gesundheitszertifikat:    ", style: TextStyle(color: Colors.white),),
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
              if(success)
              Text("Zertifikate gültig"),
              if(notValid)
                Text("Zertifikate konnten nicht gefunden werden"),
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

  Future<http.Response> checkMessageLinks() async{

    print("CHECK");
    //generate hash for expire date and birthday
    String hash1 = await generateHash(expire);
    String hash2 = await generateHash(birthdate);

    //generate leafC
    String leafC = await generateLeaf(hash1, hash2);

    //generate leafCD
    String leafCD = await generateLeaf(leafC, hashLeafD);

    //generate root
    String root = await generateRoot(hashLeafAB, leafCD);


    Map json = {'rootHash': root,
                'appInst': appInst,
                'AnnounceMsgId': AnnounceMsgId,
                'KeyloadMsgId': KeyloadMsgId,
                'SignedMsgId': SignedMsgId};
    print(json);
    return http.post(

      Uri.parse('http://192.168.0.202:8080/CheckCertificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

}