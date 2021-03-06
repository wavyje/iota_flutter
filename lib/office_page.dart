import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:iota_app/generated/l10n.dart';

import './office_scan.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  TextEditingController controller = TextEditingController();

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

              if(loggedin)
              CustomButton(onPressed: () {
                if(officeLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OfficeScan(key: UniqueKey(), doctorLoggedIn: false,)),
                  );
                }
                else if(doctorLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OfficeScan(key: UniqueKey(), doctorLoggedIn: true)),
                  );
                }
                }, buttonText: AppLocalizations.of(context)!.uploadCertificate, icon: Icons.qr_code_2_outlined),
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
      Uri.parse('http://134.106.186.38:8080/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: json,
    );
  }
}