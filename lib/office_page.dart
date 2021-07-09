import 'package:flutter/material.dart';
import 'package:iota_app/Buttons.dart';
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
              Container(padding: EdgeInsets.all(150),),

              CustomButton(onPressed: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OfficeScan()),
              );}, buttonText: "Zertfikat hochladen", icon: Icons.qr_code_2_outlined)

            ],
          ),
        ),
      ),
    );
  }
}