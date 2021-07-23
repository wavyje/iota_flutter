import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iota_app/crypto.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import './Buttons.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() {
    return _QrPageState();
  }
}

class _QrPageState extends State<QrPage> {


  var _channel;
  String _imagePath = "";
  String _json = "";
  String _links = "";
  String _expire = "";
  Map _merkleTree = Map();
  String _uuid = "";

  String _lastName = "";
  String _firstName = "";
  String _birthday = "";
  String _birthplace = "";
  String _nationality = "";
  String _address = "";
  String _hashImage = "";

  bool loading = false;
  bool success = false;

  @override
  void initState() {

      _loadData();
      _loadImage();
      _joinServer();

      //TODO: check if exists
      _loadLinks();


    _channel.stream.forEach((element) async {
      print(element);
      if(element == "RequestData")  {
        _channel.sink.add(_json);

        setState(() {
          loading = true;
        });

      }

      if(element.contains("appInst") && !element.contains("leafAB")) {
        if(!File('$_localPath/certificate.txt').existsSync()) {
          print(element);
          saveLinks(element);
          print("Links saved");

          saveCertificate();
          print("Certificate saved");

          setState(() {
            loading = false;
            success = true;
          });

          _channel.sink.close();
        }
      }
      if(element == "RequestCertificate")  {

        print("HERE" + _links);

        if(_links == "") {
          showDialog(context: context, builder: (context) {return Dialog(child: Text("Kein Zertifikat vorhanden"),);});
          return;
        }
        else {
          String jsonLinks = _links;
          // add links and expire date
          Map tmp = jsonDecode(jsonLinks);

          await getMerkleTree();
          print(_merkleTree);
          tmp['leafAB'] = _merkleTree['leafAB'];
          tmp['leafD'] = _merkleTree['leafD'];

          //add birthday
          tmp['birthday'] = jsonDecode(_json)['birthday'];

          _channel.sink.add(jsonEncode(tmp));

        }

      }

    });

      super.initState();

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
              AppBar(title: Text("IOTA HEALTH",
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
                margin: EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 0),
              ),
              CircleAvatar(backgroundImage: FileImage(File(_imagePath),
              ),
                radius: 115,
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 0),
              ),
              if(!loading && !success)
              QrImage(
                //ws://192.168.0.202:8080/cdab716e-5269-4b86-b770-bba772be4962
                data: 'UploadCertificate/' + _uuid,
                version: QrVersions.auto,
                size: 240,
                gapless: false,
              ),
              if(loading && !success)
                CircleAvatar(backgroundImage: Image
                    .asset('assets/images/IOTA_Spawn.gif')
                    .image,
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),
              if(!loading && success)
                CircleAvatar(backgroundImage: Image
                    .asset('assets/images/check.png')
                    .image,
                  radius: 100,
                  backgroundColor: Colors.transparent,
                ),
              if(!loading && success)
                Text("Zertifikat erfolgreich erstellt!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              Container(
                margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
              ),
              if(!success)
              CustomButton(onPressed: () { Navigator.pop(context,);
              },
                  buttonText: "Abbrechen",
                  icon: Icons.cancel),
              if(success)
                CustomButton(onPressed: () { Navigator.pop(context,);
                },
                    buttonText: "Okay",
                    icon: Icons.check),

            ]

        ),
      ),
    );
  }

  void _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = (prefs.getString('profile_image') ?? "Not Found");
    });
  }

  void _joinServer() {
    var uuid = Uuid();
    var u = uuid.v4();
    _uuid = u;
    print(_uuid);
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.202:8080/' + _uuid),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void _loadData() async {
    final file = await _localFile;

    //Read the file
    final contents = await file.readAsString();

    _json = contents;
  }

  void _loadLinks() async {
    final file = await _localLinkFile;

    //Read the file
    final contents = await file.readAsString();

    _links = contents;
    print("BEFORE" + _links);
  }

  //different paths and files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> get _localLinkFile async {
    final path = await _localPath;
    return File('$path/links.txt');
  }

  Future<File> get _localCertificateFile async {
    final path = await _localPath;
    return File('$path/certificate.txt');
  }

  Future<File> get _localImageFile async {
    final path = await _localPath;
    return File('$path/image');
  }

  Future<File> saveLinks(json) async{

    String jsonDataString = json.toString();

    final jsonData = jsonDecode(jsonDataString);
    _expire = jsonData['expireDate'];

    final file = await _localLinkFile;

    //Write the file

    return file.writeAsString(jsonEncode(jsonData));
  }

  Future saveCertificate() async {
    final file = await _localCertificateFile;

    Map map = {'expireDate': _expire};
    file.writeAsString(jsonEncode(map));
  }

  Future getMerkleTree() async {

    Map result = Map();

    String data = _json;
    Map jsonData = jsonDecode(data);

    result['leafAB'] = await generateLeafAB(jsonData['hashedImage'], jsonData['firstName'], jsonData['lastName'], jsonData['birthplace']);
    result['leafD'] = await generatLeafD(jsonData['address'], jsonData['nationality']);

    _merkleTree = result;
  }

}

