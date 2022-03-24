import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iota_app/about.dart';
import 'package:iota_app/generated/l10n.dart';
import 'package:iota_app/profile_page.dart';
import 'package:iota_app/qr_page.dart';
import 'package:iota_app/registration_office_page.dart';
import './DataInput.dart';
import './Buttons.dart';
import 'dart:io';
import './office_page.dart';
import './customer_scan.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

import 'doctor_page.dart';
import 'loggedinprostitute.dart';

void main() {
  runApp(MyApp());
}

// dynamically changes by input, is our container for all states
class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

// is a state, kind of static, contains the widgets
class _MyAppState extends State<MyApp> {

  static List<Widget> _pages = <Widget>[
    ProfilePage(),
    QrPage(),
    CustomerScan(),
    DoctorPage(lanr: '0',),
    RegistrationOfficePage(),
    DataInput()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar appBar = AppBar(
    title: Text('IOTA HEALTH',
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 5,

      ),

    ),
    centerTitle: false,

    actions: [
        About()
    ],
  );
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('de', ''),
      ],

      theme: ThemeData(
        canvasColor: Colors.transparent,
        primaryColor: Colors.deepPurpleAccent,

        ),

      home: Scaffold(
        extendBody: true,

        appBar: appBar,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white,),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_2_rounded, color: Colors.white,),
              label: 'Certificates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded, color: Colors.white,),
              label: 'Check',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined, color: Colors.white,),
              label: 'Doctor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house_outlined, color: Colors.white,),
              label: 'Office',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          backgroundColor: Colors.black,
          elevation: 1,
        ),
        body: _pages[_selectedIndex],
    )
    );
  }
}

class ButtonTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Form(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 90, bottom: 0),
          ),
          Text(AppLocalizations.of(context)!.checkCertificate, style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),),
          Container(margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),),
          ConstrainedBox(constraints: BoxConstraints.tightFor(width: 250),
          child: CustomButton(
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerScan())
                );
              }
              ,
            buttonText: AppLocalizations.of(context)!.scanQR,
            icon: Icons.qr_code_2_outlined,
          ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
          ),
          Text(AppLocalizations.of(context)!.saveCertificates, style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),),
          Container(margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),),
          ConstrainedBox(constraints: BoxConstraints.tightFor(width: 250),
          child: CustomButton(
            onPressed: () async {

              bool alreadyRegistered = await _localFileExists();

              if(!alreadyRegistered) {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataInput()),
            );}
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserMenu()),
                );
              }
          },
            buttonText: AppLocalizations.of(context)!.prostituteLogin,
            icon: Icons.account_circle_outlined,
          ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 150, bottom: 0),
          ),
          ConstrainedBox(constraints: BoxConstraints.tightFor(width: 207),
          child: CustomButton(
            onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OfficePage()),
            );},
            buttonText: AppLocalizations.of(context)!.authorityLogin,
            icon: Icons.house_outlined,
          ),
          ),
        ],
      )

      );
  }

}



Future<bool> _localFileExists() async {
  final path = await _localPath;

  if(await File('$path/data.txt').exists()) {
    return true;
  }
  else {
    return false;
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}