import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:iota_app/websocket_connection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';






class HealthCertificateUpload extends StatefulWidget {
  final String roomId;
  final String lanr;
  HealthCertificateUpload({required Key key, required this.roomId, required this.lanr});

  @override
  _HealthCertificateUploadState createState() {
    return _HealthCertificateUploadState(roomId: roomId, lanr: this.lanr);
  }
}

class _HealthCertificateUploadState extends State<HealthCertificateUpload> {
  final String roomId;
  final String lanr;
  var _channel;
  String firstName = "";
  String lastName = "";
  String birthday = "";
  String birthplace = "";
  String nationality = "";
  String address = "";
  String hashedImage = "";
  String expireDate = "";
  String hashLeafAB = "";
  String hashLeafD = "";
  String appInst = "";
  String KeyloadMsgId = "";
  String SignedMsgId = "";
  String AnnounceMsgId = "";
  String pskSeed = "";

  bool dataArrived = false;
  bool loading = false;
  bool success = false;
  bool registrationValid = false;
  TextEditingController controller = TextEditingController();

  _HealthCertificateUploadState({required this.roomId, required this.lanr});

  @override
  void initState() {

    _joinServer();
    //TODO: if joinserver not successful
    _sendRequestData();

    _channel.stream.forEach((element) async {
      print(element);
      if(element.contains("hashedImage") && element.contains("firstName")) {
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
        _channel.sink.add("RequestCertificate");
      }

      if(element.contains("appInst") && element.contains("leafAB")) {
        print(element);
        setState(() {
          expireDate = jsonDecode(element)['expireDate'];
          hashLeafAB = jsonDecode(element)['leafAB'];
          hashLeafD = jsonDecode(element)['leafD'];
          appInst = jsonDecode(element)['appInst'];
          KeyloadMsgId = jsonDecode(element)['KeyloadMsgId'];
          SignedMsgId = jsonDecode(element)['SignedMsgId'];
          AnnounceMsgId = jsonDecode(element)['AnnounceMsgId'];
          pskSeed = jsonDecode(element)['PskSeed'];



          dataArrived = true;
          loading = true;
        });
        print("here");
        var response = await checkMessageLinks();

        if(response.statusCode == 200) {
          setState(() {
            registrationValid = true;
            print("valid");
          });
        }
        else {
          print("what");

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
          title: Text(AppLocalizations.of(context)!.certificates,
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
              Text(AppLocalizations.of(context)!.firstName + ": " + firstName, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text(AppLocalizations.of(context)!.lastName + ": " + lastName, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text(AppLocalizations.of(context)!.birthday + ": " + birthday, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text(AppLocalizations.of(context)!.birthplace + ": " + birthplace, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text(AppLocalizations.of(context)!.nationality + ": " + nationality, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              Text(AppLocalizations.of(context)!.address + ": " + address, style: TextStyle(color: Colors.white),),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              if(dataArrived && !success && registrationValid)
                CustomButton(onPressed: () { getResponse(); },
                    buttonText: AppLocalizations.of(context)!.uploadCertificate, icon: Icons.check),
              Container(
                margin: EdgeInsets.only(left:0, top:30, right:0, bottom:0),
              ),
              if(registrationValid && !success)
                Text(AppLocalizations.of(context)!.healthCertificateUpload + expireDate, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              /*if(loading)
                CircleAvatar(backgroundImage: Image
                    .asset('assets/images/IOTA_Spawn.gif')
                    .image,
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),*/
              if(success)
                CircleAvatar(backgroundImage: Image
                    .asset('assets/images/check.png')
                    .image,
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),
              if(success)
                CustomButton(onPressed: () {
                  Navigator.of(context).pop();
                }, buttonText: "Return", icon: Icons.check)
            ],
          ),
          ),
        ),
      ),
    );
  }


  void _joinServer() {
    var ipAddress = WebsocketConnection().ipAddress;
    _channel = WebSocketChannel.connect(
      Uri.parse(ipAddress + roomId),
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
      'expire': expireDate,
      'KeyloadMsgId': KeyloadMsgId,
      'SignedMsgId': SignedMsgId,
      'PskSeed': pskSeed,
      'lanr': lanr,
      'appInst': appInst};
    print(json);
    return http.post(

      Uri.parse(WebsocketConnection().httpAddress + 'healthCertificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  Future<http.Response> sendPassword(data) {
    Map json = {'password': data};
    return http.post(
      Uri.parse(WebsocketConnection().httpAddress + 'login'),
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

            Container(
              margin: EdgeInsets.only(
                  left: 0, top: 10, right: 0, bottom: 0),
            ),
            CustomButton(onPressed: () async {

              Navigator.of(context).pop();


                var response = await createAlbum(await generateHash(controller.text), firstName, lastName, birthday, birthplace, nationality, address, hashedImage);

                if(response.statusCode == 200) {
                  //print(response.body);
                  Map links = jsonDecode(response.body);
                  links['expireDate'] = expireDate;
                  //print(links);
                  var linksjson = jsonEncode(links);
                  print(linksjson);
                  _channel.sink.add(linksjson);
                  _channel.sink.close();



                  setState(() {
                    success = true;
                  });


                }
                else {
                  Navigator.of(context).pop("error");
                }

                //then createAlbum



            },
                buttonText: "Confirm",
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

  String expire() {
    DateTime rn = DateTime.now();
    print(rn);
    DateTime expire = rn.add(new Duration(days: 365));
    final df = new DateFormat('dd-MM-yyyy');
    final expireFormat =  df.format(expire);
    expireDate = expireFormat;
    return expireFormat;
  }

  Future<http.Response> checkMessageLinks() async{

    print("CHECK");
    //generate hash for expire date and birthday
    String hash1 = await generateHash(expireDate);
    String hash2 = await generateHash(birthday);

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
      'SignedMsgId': SignedMsgId,
      'PskSeed': pskSeed};
    print(json);
    String j = jsonEncode(json);
    return http.post(

      Uri.parse(WebsocketConnection().httpAddress + 'CheckCertificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }
}