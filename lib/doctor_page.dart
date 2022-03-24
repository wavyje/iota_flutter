

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

  bool loggedIn = false;
  bool officeLoggedIn = false;
  bool doctorLoggedIn = false;
  bool passwordIncorrect = false;
  bool loginUnsuccessful = false;
  bool doctorBlacklisted = false;
  bool lanrInvalid = false;
  bool lanrAlreadyInDatabase = false;


  bool registration = false;
  bool registrationSuccessful = false;

  TextEditingController controller = TextEditingController();
  TextEditingController passwordDoctor = TextEditingController();
  TextEditingController passwordRegistrationOffice = TextEditingController();
  TextEditingController lanrCtr = TextEditingController();
  TextEditingController name = TextEditingController();

  final String lanr;

  AppBar appBar = AppBar(
    title: Text('IOTA HEALTH',
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 5,
      ),
    ),
    centerTitle: true,
  );


  @override
  Widget build(
      BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,

    ),

    home: Scaffold(
      resizeToAvoidBottomInset: false,
    body: Container(
      width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
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
      if(!loggedIn)
      CustomButton(onPressed: () {
        setState(() {
          registration = false;
          lanrInvalid = false;
          lanrAlreadyInDatabase = false;
        });
        showDialog(context: context, builder: (BuildContext context)
        {
          return StatefulBuilder(
              builder: (
                  context,
                  setState) {
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
                        Form(child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min,
                              children: <Widget>[
                                if(!registrationSuccessful)
                                  Padding(
                                    padding: EdgeInsets
                                        .all(
                                        8.0),
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          loginUnsuccessful = false;
                                          doctorBlacklisted = false;
                                          lanrInvalid = false;
                                          lanrAlreadyInDatabase = false;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Lebenslange Arztnummer",
                                          hintText: "453576301"
                                      ),
                                      controller: lanrCtr,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)!.obligatoryField;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                if(registration)
                                  Padding(
                                    padding: EdgeInsets
                                        .all(
                                        8.0),
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          loginUnsuccessful = false;
                                          doctorBlacklisted = false;
                                          lanrInvalid = false;
                                          lanrAlreadyInDatabase = false;
                                        }); },
                                      decoration: InputDecoration(
                                          labelText: AppLocalizations
                                              .of(
                                              context)!
                                              .firstName +
                                              " and " +
                                              AppLocalizations
                                                  .of(
                                                  context)!
                                                  .lastName,
                                          hintText: "Gregory House"
                                      ),
                                      controller: name,
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
                                if(!registrationSuccessful)
                                  Padding(
                                    padding: EdgeInsets
                                        .all(
                                        8.0),
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          loginUnsuccessful = false;
                                          doctorBlacklisted = false;
                                          lanrInvalid = false;
                                          lanrAlreadyInDatabase = false;
                                        }); },
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations
                                            .of(
                                            context)!
                                            .password,

                                      ),
                                      obscureText: true,
                                      controller: passwordDoctor,
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
                                if(!registration && !registrationSuccessful)
                                  Padding(
                                    padding: const EdgeInsets
                                        .all(
                                        8.0),
                                    child: CustomButton(

                                      buttonText: "Login",
                                      onPressed: () async {

                                        setState(() {
                                          loginUnsuccessful = false;
                                          doctorBlacklisted = false;
                                          lanrInvalid = false;
                                          lanrAlreadyInDatabase = false;
                                        });

                                        var response = await sendLogin();

                                        if(response.statusCode == 200) {
                                          print(response.statusCode);

                                          setState(() {
                                            loggedIn = true;

                                          });

                                          Navigator.pop(context);


                                        }
                                        else if(response.statusCode == 400) {
                                          setState(() {
                                            doctorBlacklisted = true;
                                            loginUnsuccessful = false;
                                          });
                                        }
                                        else {
                                          setState(() {
                                            loginUnsuccessful = true;
                                            doctorBlacklisted = false;
                                          });

                                        }
                                      },
                                      icon: Icons.check,
                                    ),
                                  ),
                                if(loginUnsuccessful)
                                  Padding(
                                      padding: EdgeInsets.all(8.0),child: Text("Password incorrect or User not existing!")),
                                if(doctorBlacklisted)
                                  Padding(
                                      padding: EdgeInsets.all(8.0),child: Text("Access denied, because LANR is on blacklist!")),
                                if(!registration && !registrationSuccessful)
                                  Padding(
                                    padding: const EdgeInsets
                                        .all(
                                        4.0),
                                    child: ElevatedButton(
                                      child: Text(
                                          "Register Here"),
                                      onPressed: () {
                                        setState(() {
                                          registration =
                                          true;
                                        });

                                      },
                                    ),
                                  ),
                                if(registration)
                                  Padding(
                                    padding: const EdgeInsets
                                        .all(
                                        4.0),
                                    child: ElevatedButton(
                                      child: Text(
                                          "Register"),
                                      onPressed: () async {

                                        FocusScope.of(context).requestFocus(FocusNode());

                                        var response = await sendRegistration(passwordDoctor.text);

                                        if(response.statusCode == 200) {
                                          setState(() {
                                            registration =
                                            false;
                                            registrationSuccessful =
                                            true;
                                          });
                                        }
                                        else if(response.statusCode == 409) {
                                          setState (() {
                                            lanrAlreadyInDatabase = true;
                                          });
                                        }
                                        else {
                                          setState (() {
                                            lanrInvalid = true;
                                          });
                                        }

                                      },
                                    ),
                                  ),
                                if(registrationSuccessful)
                                  Padding(
                                      padding: EdgeInsets.all(8.0),child: Text("Registration Successful!")),
                                if(lanrInvalid)
                                  Padding(
                                      padding: EdgeInsets.all(8.0),child: Text("LANR is invalid!")),
                                if(lanrAlreadyInDatabase)
                                  Padding(
                                      padding: EdgeInsets.all(8.0),child: Text("LANR is already in database!")),
                                if(registrationSuccessful)
                                  CustomButton(onPressed: () {
                                    setState(() {
                                      registrationSuccessful = false;
                                    });
                                  }, buttonText: "Okay", icon: Icons.check)
                              ],
                            ))
                        )
                      ]
                  ),
                );
              }
          );
        });
      }
          , buttonText: "Doctor Login", icon: Icons.account_circle_outlined),
    if(loggedIn)
    CustomButton(onPressed: () async {
      print(this.lanr);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OfficeScan(key: UniqueKey(), doctorLoggedIn: true, lanr: this.lanrCtr.text,)),
      );
    },
    buttonText: AppLocalizations.of(context)!.uploadCertificate,
    icon: Icons.qr_code_2_outlined,
    ),
      Container(padding: EdgeInsets.all(20),),
      if(loggedIn)
      CustomButton(onPressed: () async {

        await showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(content: Stack(
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
                    Text("Do you really want to delete your profile?"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(onPressed: () async {
                          print(lanrCtr.text);
                          var response = await sendRemoveRequest(lanrCtr.text);

                          print(response.statusCode);

                          if(response.statusCode == 200) {


                            setState(() {
                              loggedIn = false;
                            });

                            Navigator.pop(
                                context);

                          }

                        }, buttonText: "Confirm", icon: Icons.check),
                        Container(padding: EdgeInsets.all(10),),
                        CustomButton(onPressed: () {
                          Navigator.pop(context);
                        }, buttonText: "Cancel", icon: Icons.cancel),
                      ],
                    )

                  ],
                )


              ]
          ));
        });

      },
        buttonText: "Remove Profile",
        icon: Icons.account_circle_outlined,
      ),


    ],
    )
    )
    )
    ,

    );
  }

  // checks password for office login
  Future<http.Response> sendLogin() async {

    String pw = await generateHash(passwordDoctor.text);
    print(pw);
    Map json = {'lanr': lanrCtr.text,
      'password': pw};
    return http.post(
      Uri.parse(WebsocketConnection().httpAddress + 'doctor_login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  // sends request for registration
  Future<http.Response> sendRegistration(password) async {

    String pw = await generateHash(password);
    print(pw);
    Map json = {'lanr': lanrCtr.text,
      'name': name.text,
      'password': pw};
    return http.post(
      Uri.parse(WebsocketConnection().httpAddress + 'doctor_first_login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
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

// puts doctor on blacklist
Future<http
    .Response> sendRemoveRequest(lanr) async {


  Map json = {'lanr': lanr};
  return http.post(
    Uri.parse(
        WebsocketConnection().httpAddress + 'remove_doctor'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: json,
  );
}