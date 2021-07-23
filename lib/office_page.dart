import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
import 'package:http/http.dart' as http;

import './office_scan.dart';

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
              buttonText: "Passwort eingeben",
                icon: Icons.forward,
              ),
              if(passwordIncorrect)
                Text("Passwort falsch"),

              if(loggedin)
              CustomButton(onPressed: () {
                if(officeLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OfficeScan()),
                  );
                }
                else if(doctorLoggedIn) {

                }
                }, buttonText: "Zertfikat hochladen", icon: Icons.qr_code_2_outlined),
              Container(padding: EdgeInsets.only(bottom: 300),)
            ],
          ),
        ),
        ]
        ),
      ),
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
}