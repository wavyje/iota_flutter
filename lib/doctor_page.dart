

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:iota_app/generated/l10n.dart';

import './office_scan.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'websocket_connection.dart';

class DoctorPage
    extends StatefulWidget {

  final String lanr;

  DoctorPage({required this.lanr});

  @override
  State<
      StatefulWidget> createState() {
    // TODO: implement createState
    return _DoctorPageState(lanr: this.lanr);
  }
}

// is a state, kind of static, contains the widgets
class _DoctorPageState
    extends State<DoctorPage> {

  _DoctorPageState({required this.lanr});

  final _formKey = GlobalKey<
      FormState>();

  bool blacklistRequestUnsuccessful = false;
  bool blacklistRequestSuccessful = false;

  final String lanr;


  @override
  Widget build(
      BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,

    ),

    home: Scaffold(
    appBar: AppBar(
    title: Text('IOTA HEALTH',
    style: TextStyle(
    color: Colors.white,
    letterSpacing: 5,
    ),
    ),
    centerTitle: true,
    ),
    body: new ListView(

    children: <Widget>[Container(
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
    Container(padding: EdgeInsets.all(100),),

    /*
     * Button for uploading the registration certificate
     */

    CustomButton(onPressed: () async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OfficeScan(key: UniqueKey(), doctorLoggedIn: true, lanr: this.lanr,)),
      );
    },
    buttonText: AppLocalizations.of(context)!.uploadCertificate,
    icon: Icons.qr_code_2_outlined,
    ),


    ],
    ))]
    )
    ,
    )
    );
  }
}

// checks password for office login
Future<http
    .Response> sendPassword(
    data) async {
  print(data);
  String pw = await generateHash(
      data);
  print(pw);
  Map json = {'password': pw};
  return http.post(
    Uri.parse(
        WebsocketConnection()
            .httpAddress +
            'login_registration_office'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: json,
  );
}

// puts doctor on blacklist
Future<http
    .Response> sendBlacklistRequest(data) async {
  print(data);

  Map json = {'lanr': data};
  return http.post(
    Uri.parse(
        WebsocketConnection().httpAddress + 'put_blacklist'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: json,
  );
}