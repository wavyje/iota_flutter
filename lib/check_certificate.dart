import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:iota_app/websocket_connection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




// site for checking the certificate
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
  String expireRegistration = "";
  String expireHealth = "";
  String birthdate = "";
  String hashLeafD = "";
  String rootHash = "";
  String appInst = "";
  String AnnounceMsgId = "";
  String KeyloadMsgId = "";
  String SignedMsgId = "";
  String TaggedMsgId = "";
  String pskSeed = "";

  bool dataArrived = false;
  bool registrationLoading = false;
  bool healthCertificateLoading = false;
  bool registrationSuccess = false;
  bool healthCertificateSuccess = false;
  bool registrationNotValid = false;
  bool healthCertificateNotValid = false;
  bool doctorBlacklisted = false;

  TextEditingController controller = TextEditingController();

  _CertificateCheckState({required this.roomId});

  @override
  void initState() {

    _joinServer();
    //TODO: if joinserver not successful
    // requests certificate data
    _sendRequestCertificate();

    // listen for messages on the websocket
    _channel.stream.forEach((element) async {
      if(element.contains("appInst") && element.contains("leafAB")) {
        print(element);
        setState(() {
          birthdate = jsonDecode(element)['birthday'];
          expireRegistration = jsonDecode(element)['expireDate'];
          expireHealth = jsonDecode(element)['expireHealth'];
          hashLeafAB = jsonDecode(element)['leafAB'];
          hashLeafD = jsonDecode(element)['leafD'];
          appInst = jsonDecode(element)['appInst'];
          KeyloadMsgId = jsonDecode(element)['KeyloadMsgId'];
          SignedMsgId = jsonDecode(element)['SignedMsgId'];
          AnnounceMsgId = jsonDecode(element)['AnnounceMsgId'];
          TaggedMsgId = jsonDecode(element)['TaggedMsgId'];
          pskSeed = jsonDecode(element)['PskSeed'];

          dataArrived = true;
          registrationLoading = true;
          healthCertificateLoading = true;
        });

        var response = await checkMessageLinks();

        print("HCECKCEKC");
        if(response.statusCode == 200) {
          setState(() {
            registrationLoading = false;
            registrationSuccess = true;
          });

          print("FAFSFS");
        }
        else {
          setState(() {
            registrationNotValid = true;
          });

          print("NMICHT GUT");
        }

       var secondResponse = await checkHealthCertificate();
        print(secondResponse.statusCode);
        if(secondResponse.statusCode == 200) {
          setState(() {
            healthCertificateLoading = false;
            healthCertificateSuccess = true;
          });
        }
        else if(secondResponse.statusCode == 400) {
          setState(() {
            healthCertificateLoading = false;
            doctorBlacklisted = true;
          });
        }
        else if(secondResponse.statusCode == 403) {
          setState(() {
            healthCertificateLoading = false;
            doctorBlacklisted = true;
          });
        }
        else {
          setState(() {
            healthCertificateNotValid = true;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        alignment: Alignment
            .center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment
                .topLeft,
            end: Alignment
                .bottomRight,
            colors: <Color>[
              Colors
                  .deepPurpleAccent,
              //Color(0xFFE1BEE7),
              Colors
                  .purpleAccent
            ],

          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets
                  .only(
                  left: 0,
                  top: 30,
                  right: 0,
                  bottom: 0),
            ),
            Text(
              AppLocalizations
                  .of(
                  context)!
                  .birthday +
                  ": " +
                  birthdate,
              style: TextStyle(
                  color: Colors
                      .white,
                  fontWeight: FontWeight
                      .bold),),
            Container(
              margin: EdgeInsets
                  .only(
                  left: 0,
                  top: 30,
                  right: 0,
                  bottom: 0),
            ),

            Container(
              margin: EdgeInsets
                  .only(
                  left: 0,
                  top: 30,
                  right: 0,
                  bottom: 0),
            ),
            if(!registrationSuccess ||
                !healthCertificateSuccess)
              Text(
                  AppLocalizations
                      .of(
                      context)!
                      .searchingNetwork),
            Row(
              children: [
                Container(
                  margin: EdgeInsets
                      .only(
                      left: 20,
                      top: 30,
                      right: 0,
                      bottom: 0),),
                Text(
                  AppLocalizations
                      .of(
                      context)!
                      .registrationCertificate +
                      ":    ",
                  style: TextStyle(
                      color: Colors
                          .white,
                      fontWeight: FontWeight
                          .bold),),
                if(registrationLoading)
                  CircleAvatar(
                    backgroundImage: Image
                        .asset(
                        'assets/images/IOTA_Spawn.gif')
                        .image,
                    radius: 20,
                    backgroundColor: Colors
                        .transparent,
                  ),
                if(registrationSuccess)
                  CircleAvatar(
                    backgroundImage: Image
                        .asset(
                        'assets/images/check.png')
                        .image,
                    radius: 20,
                    backgroundColor: Colors
                        .transparent,
                  ),
              ],
            ),
            if(registrationSuccess)
              Text(
                AppLocalizations
                    .of(
                    context)!
                    .expirationDate +
                    ": " +
                    expireRegistration,
                style: TextStyle(
                    color: Colors
                        .white),),
            Container(
              margin: EdgeInsets
                  .only(
                  top: 20),),
            Row(
              children: [
                Container(
                  margin: EdgeInsets
                      .only(
                      left: 20,
                      top: 20,
                      right: 0,
                      bottom: 0),),
                Text(
                  AppLocalizations
                      .of(
                      context)!
                      .healthCertificate +
                      ":    ",
                  style: TextStyle(
                      color: Colors
                          .white,
                      fontWeight: FontWeight
                          .bold),),
                if(healthCertificateLoading)
                  CircleAvatar(
                    backgroundImage: Image
                        .asset(
                        'assets/images/IOTA_Spawn.gif')
                        .image,
                    radius: 20,
                    backgroundColor: Colors
                        .transparent,
                  ),
                if(healthCertificateSuccess)
                  CircleAvatar(
                    backgroundImage: Image
                        .asset(
                        'assets/images/check.png')
                        .image,
                    radius: 20,
                    backgroundColor: Colors
                        .transparent,
                  ),
              ],
            ),
            if(healthCertificateSuccess)
              Text(
                AppLocalizations
                    .of(
                    context)!
                    .expirationDate +
                    ": " +
                    expireHealth,
                style: TextStyle(
                    color: Colors
                        .white),),
            Container(
              margin: EdgeInsets
                  .only(
                  left: 0,
                  top: 30,
                  right: 0,
                  bottom: 0),
            ),
            if(registrationSuccess &&
                healthCertificateSuccess)
              Text(
                AppLocalizations
                    .of(
                    context)!
                    .certificatesValid,
                style: TextStyle(
                    fontWeight: FontWeight
                        .bold,
                    fontSize: 14),),
            if(registrationNotValid)
              Text(
                  AppLocalizations
                      .of(
                      context)!
                      .registrationCertificateNotFound),
            if(healthCertificateNotValid)
              Text(
                  AppLocalizations
                      .of(
                      context)!
                      .healthCertificateNotFound),
            if(doctorBlacklisted)
              Text(
                  "Doctor is blacklisted! Certificate therefore is not valid")
          ],
        ),
      ),

    );
  }

  // joins the websocket
  void _joinServer() {
    var ipAddress = WebsocketConnection().ipAddress;
    _channel = WebSocketChannel.connect(
      Uri.parse(ipAddress + roomId),
    );
  }

  // requests the certificate data
  void _sendRequestCertificate() {
    _channel.sink.add("RequestCertificate");
  }

  // disposes the websocket stream
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  //calculate root hash for registration and send post request with IOTA Streams message links
  Future<http.Response> checkMessageLinks() async{

    print("CHECK");
    //generate hash for expire date and birthday
    String hash1 = await generateHash(expireRegistration);
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
                'SignedMsgId': SignedMsgId,
                'PskSeed': pskSeed};
    print(json);
    return http.post(

      Uri.parse(WebsocketConnection().httpAddress + 'CheckCertificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  //calculate root hash for health certificate and send post request with IOTA Streams message links
  Future<http.Response> checkHealthCertificate() async{

    print("CHECK");
    //generate hash for expire date and birthday
    String hash1 = await generateHash(expireHealth);
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
      'TaggedMsgId': TaggedMsgId,
      'PskSeed': pskSeed};
    print(json);
    return http.post(

      Uri.parse(WebsocketConnection().httpAddress + 'CheckHealthCertificate'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

}