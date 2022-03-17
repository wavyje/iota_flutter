

import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:iota_app/generated/l10n.dart';

import './office_scan.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'websocket_connection.dart';

class RegistrationOfficePage
    extends StatefulWidget {

  @override
  State<
      StatefulWidget> createState() {
    // TODO: implement createState
    return _RegistrationOfficePageState();
  }
}

// is a state, kind of static, contains the widgets
class _RegistrationOfficePageState
    extends State<RegistrationOfficePage> {

  final _formKey = GlobalKey<
      FormState>();

  bool blacklistRequestUnsuccessful = false;
  bool blacklistRequestSuccessful = false;
  bool removeRequestUnsuccessful = false;
  bool removeRequestSuccessful = false;

  TextEditingController lanr = TextEditingController();


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
        MaterialPageRoute(builder: (context) => OfficeScan(key: UniqueKey(), doctorLoggedIn: false, lanr: "0",)),
      );
    },
    buttonText: AppLocalizations.of(context)!.uploadCertificate,
    icon: Icons.qr_code_2_outlined,
    ),

    //button for blacklisting a doctor
    CustomButton(
    buttonText: "Blacklist",
    icon: Icons.warning_amber_outlined,
    onPressed: () {
    setState(() {
      blacklistRequestSuccessful = false;
      blacklistRequestUnsuccessful = false;
    });
    showDialog(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState)
      {
        return AlertDialog(
            content: Stack(
                clipBehavior: Clip
                    .hardEdge,
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
                  Form(
                      child: Column(
                          mainAxisSize: MainAxisSize
                              .min,
                          children: <
                              Widget>[
                                if(!blacklistRequestSuccessful)
                            Padding(
                              padding: EdgeInsets
                                  .all(
                                  8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Lebenslange Arztnummer",
                                ),
                                controller: lanr,
                                validator: (
                                    value) {
                                  if (value ==
                                      null ||
                                      value
                                          .isEmpty) {
                                    return AppLocalizations
                                        .of(
                                        context)!
                                        .obligatoryField;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if(!blacklistRequestSuccessful)
                            CustomButton(
                                onPressed: () async {
                                  setState(() {
                                    blacklistRequestUnsuccessful =
                                    false;
                                  });
                                  var response = await sendBlacklistRequest(
                                      lanr
                                          .text);

                                  if (response.statusCode != 200) {
                                    setState(() {
                                      blacklistRequestUnsuccessful =
                                      true;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      blacklistRequestSuccessful = true;
                                    });
                                  }

                                },
                                buttonText: "Put On Blacklist",
                                icon: Icons
                                    .warning_amber_outlined),
                            CustomButton(
                                onPressed: () async {
                                  setState(() {
                                    blacklistRequestUnsuccessful =
                                    false;
                                  });
                                  var response = await removeBlacklistRequest(
                                      lanr
                                          .text);

                                  if (response.statusCode != 200) {
                                    setState(() {
                                      removeRequestUnsuccessful =
                                      true;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      removeRequestSuccessful = true;
                                    });
                                  }

                                },
                                buttonText: "Remove from Blacklist",
                                icon: Icons
                                    .warning_amber_outlined),
                            if(blacklistRequestUnsuccessful)
                              Padding(
                                  padding: EdgeInsets
                                      .all(
                                      4.0),
                                  child: Text(
                                      "Doctor is already blacklisted or database not reachable!")),
                            if(blacklistRequestSuccessful)
                              Padding(
                              padding: EdgeInsets.all(4.0), child: Text(
                                "Doctor successfully blacklisted!")),
                            if(blacklistRequestSuccessful)
                              CustomButton(onPressed: () {Navigator.pop(context);}, buttonText: "Okay", icon: Icons.check),
                            if(removeRequestUnsuccessful)
                              Padding(
                                  padding: EdgeInsets
                                      .all(
                                      4.0),
                                  child: Text(
                                      "Doctor is not on blacklist!")),
                            if(removeRequestSuccessful)
                              Padding(
                                  padding: EdgeInsets.all(4.0), child: Text(
                                  "Doctor successfully removed!")),
                            if(removeRequestSuccessful)
                              CustomButton(onPressed: () {Navigator.pop(context);}, buttonText: "Okay", icon: Icons.check)
                          ]
                      )
                  )


                ]
            )
        );
      });
    },
    );


    })
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
    .Response> sendBlacklistRequest(lanr) async {
  print(lanr);

  Map json = {'lanr': lanr};
  return http.post(
    Uri.parse(
        WebsocketConnection().httpAddress + 'put_blacklist'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: json,
  );
}

// remove doctor from blacklist
Future<http
    .Response> removeBlacklistRequest(lanr) async {
  print(lanr);

  Map json = {'lanr': lanr};
  return http.post(
    Uri.parse(
        WebsocketConnection().httpAddress + 'remove_from_blacklist'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: json,
  );
}