import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:iota_app/doctor_page.dart';
import 'package:iota_app/generated/l10n.dart';
import 'package:iota_app/registration_office_page.dart';

import './office_scan.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'websocket_connection.dart';

class OfficePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OfficePageState();
  }
}

// is a state, kind of static, contains the widgets
class _OfficePageState extends State<OfficePage> {

  bool loggedin = false;
  bool officeLoggedIn = false;
  bool doctorLoggedIn = false;
  bool passwordIncorrect = false;
  bool loginUnsuccessful = false;
  bool doctorBlacklisted = false;

  final _formKey = GlobalKey<FormState>();

  bool registration = false;
  bool registrationSuccessful = false;

  TextEditingController controller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController lanr = TextEditingController();
  TextEditingController name = TextEditingController();

  void dd() {
    // for different input, calls build method and rebuilds the widget tree
    setState(() {
      var nextPage = 0;
    });
    print('Button pressed');
  }

  @override
  Widget build(BuildContext context) {
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
              if(!loggedin)
               TextFormField(decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
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
              if(!loggedin)
              CustomButton(onPressed: () async {
                var response = await sendPassword(controller.text);

                if (response.statusCode == 200) {
                  if (response.body == "office") {
                    setState(() {
                      loggedin = true;
                      officeLoggedIn = true;
                      passwordIncorrect = false;
                    });
                  }
                  else if (response.body == "doctor") {
                    setState(() {
                      loggedin = true;
                      doctorLoggedIn = true;
                      passwordIncorrect = false;
                    });
                  }
                }
                else {
                  setState(() {
                    passwordIncorrect = true;
                  });
                }
              },
              buttonText: "Login",
                icon: Icons.forward,
              ),
              if(passwordIncorrect)
                Text(AppLocalizations.of(context)!.passwordIncorrect),



              CustomButton(onPressed: () {
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
                                Form(
                                    child: Column(
                                      mainAxisSize: MainAxisSize
                                          .min,
                                      children: <
                                          Widget>[
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
                                              });
                                            },
                                            decoration: InputDecoration(
                                                labelText: "Lebenslange Arztnummer",
                                                hintText: "453576301"
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
                                                }); },
                                            decoration: InputDecoration(
                                              labelText: AppLocalizations
                                                  .of(
                                                  context)!
                                                  .password,

                                            ),
                                            controller: password,
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
                                            child: ElevatedButton(
                                              child: Text(
                                                  "Login"),
                                              onPressed: () async {
                                                  var response = await sendLogin();

                                                  if(response.statusCode == 200) {
                                                    print(response.statusCode);


                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => DoctorPage(lanr: this.lanr.text))
                                                    );
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

                                                var response = await sendRegistration(password.text);

                                                if(response.statusCode == 200)
                                                  setState(() {
                                                    registration = false;
                                                    registrationSuccessful = true;
                                                });

                                              },
                                            ),
                                          ),
                                          if(registrationSuccessful)
                                          Padding(
                                            padding: EdgeInsets.all(8.0),child: Text("Registration Successful!")),
                                          if(registrationSuccessful)
                                            CustomButton(onPressed: () {
                                              setState(() {
                                                registrationSuccessful = false;
                                              });
                                            }, buttonText: "Okay", icon: Icons.check)
                                      ],
                                    ))
                              ]
                          ),
                        );
                      }
                  );
                });
              }
              , buttonText: "Doctor", icon: Icons.account_circle_outlined),
              CustomButton(onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          Form(child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!.password,
                                  ),
                                  controller: password,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.obligatoryField;
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text("Login"),
                                  onPressed: () async {


                                      var response = await sendPassword(password.text);

                                      if (response.statusCode == 200) {

                                          setState(() {
                                            loggedin = true;
                                            officeLoggedIn = true;
                                            passwordIncorrect = false;
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RegistrationOfficePage()),
                                          );
                                      }
                                      else {
                                        setState(() {
                                          passwordIncorrect = true;
                                        });
                                      }
                                    },

                                ),
                              ),
                              if(passwordIncorrect)
                                Text(AppLocalizations.of(context)!.passwordIncorrect),
                            ],
                          ))
                        ]
                    ),
                  );
                }
                );
              }
                  , buttonText: "Registration Office", icon: Icons.house_outlined),
              Container(padding: EdgeInsets.only(bottom: 400),)
            ],
          ),
        ),
        ]
        ),
      ),
    );
  }

  // checks password for office login
  Future<http.Response> sendPassword(data) async {
    print(data);
    String pw = await generateHash(data);
    print(pw);
    Map json = {'password': pw};
    return http.post(
      Uri.parse(WebsocketConnection().httpAddress + 'login_registration_office'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }

  // checks password for office login
  Future<http.Response> sendLogin() async {

    String pw = await generateHash(password.text);
    print(pw);
    Map json = {'lanr': lanr.text,
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
    Map json = {'lanr': lanr.text,
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