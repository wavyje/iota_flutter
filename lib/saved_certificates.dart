import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// page for displaying the certificate expiriation dates
class CertificatePage extends StatefulWidget {
  @override
  _CertificatePageState createState() {
    return _CertificatePageState();
  }
}

class _CertificatePageState extends State<CertificatePage> {

  String _expireHealth = "";
  String _expireRegistration = "";

  bool registered = false;
  bool healthCheckUp = false;

  @override
  void initState() {
    super.initState();
    _loadCertificate();
  }

  // for different input, calls build method and rebuilds the widget tree

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
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
              AppBar(title: Text(AppLocalizations.of(context)!.certificates,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
                elevation: 25,
                centerTitle: true,
                toolbarOpacity: 0.8,
              ),
              Container(
                margin: EdgeInsets.only(left:0, top:100, right:0, bottom:0),
              ),

                  Text(AppLocalizations.of(context)!.registrationCertificate + ": ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),),
                  if(registered)
                    Text(AppLocalizations.of(context)!.expirationDate + " " + _expireRegistration, style: TextStyle(color: Colors.white, fontSize: 18),),
                  if(!registered)
                    Text(AppLocalizations.of(context)!.notExisting),

                  Container(
                    margin: EdgeInsets.only(left:0, top:100, right:0, bottom:0),
                  ),
                  Text(AppLocalizations.of(context)!.healthCertificate + ": ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),),
                  if(healthCheckUp)
                    Text(AppLocalizations.of(context)!.expirationDate + ": " + _expireHealth, style: TextStyle(color: Colors.white, fontSize: 18),),
                  if(!healthCheckUp)
                    Text(AppLocalizations.of(context)!.notExisting)
                    ]
                ),

              ),
    );
  }

  // loads the certificate expiration date
  void _loadCertificate() async {

    final path = await _localPath;

    if(File('$path/certificate.txt').existsSync()) {
      final file = await _localCertificate;

      final contents = await file.readAsString();

      if (contents != "") {
        final Map<String, dynamic> map = jsonDecode(contents);

        setState(() {
          _expireRegistration = map['expireDateRegistration'];
          _expireHealth = map['expireDateHealth'];
        });
        if(_expireRegistration != "") {
          registered = true;
        }
        if(_expireHealth != "") {
          healthCheckUp = true;
        }
      }
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localCertificate async {
    final path = await _localPath;

    return File('$path/certificate.txt');
  }
}