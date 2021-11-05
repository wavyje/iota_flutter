import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:iota_app/imagePicker.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import './loggedinprostitute.dart';
import './imagePicker.dart';
import './Buttons.dart';
import './crypto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {

  final _formKey = GlobalKey<FormState>();

  bool image = false;

  var maskFormatter = new MaskTextInputFormatter(mask: '##-##-####', filter: { "#": RegExp(r'[0-9]') });

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController birthplace = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController address = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.person, color: Colors.white,),
            labelText: "AppLocalizations.of(context)!.firstName", labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white
          ),
            cursorColor: Colors.white,
            controller: firstName,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pflichtfeld';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.home),
            labelText: 'Nachname', labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white
          ),
            cursorColor: Colors.white,
            controller: lastName,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pflichtfeld';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: 'Geburtstag',labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white,
            hintText: "dd-mm-yyyy"
          ),
            cursorColor: Colors.white,
            controller: birthday,
            keyboardType: TextInputType.number,
            inputFormatters: [maskFormatter],

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pflichtfeld';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.local_hospital),
            labelText: 'Geburtsort',labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white
          ),
            cursorColor: Colors.white,
            controller: birthplace,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pflichtfeld';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
              icon: Icon(Icons.flag_outlined),
              labelText: 'Staatsangehörigkeit',labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white
          ),
            cursorColor: Colors.white,
            controller: nationality,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pflichtfeld';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: 'Addresse',labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white,
            hintText: "Straße Hausnummer, PLZ Wohnort"
          ),
            cursorColor: Colors.white,
            controller: address,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pflichtfeld';
              }
              return null;
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          ),
          CustomButton(
            onPressed: () {
              getImage(ImageSource.gallery).then((value) => image = value);
            },
            buttonText: "Bild auswählen",
            icon: Icons.image
          ),
          Text("Gesicht muss eindeutig identifizierbar sein", style: TextStyle(color: Colors.white),),
          if(!image)
            Text("Ein Bild muss hochgeladen werden", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          if(image)
            Text("Bild erfolgreich ausgewählt!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 150, bottom: 0),
          ),
          CustomButton(
            onPressed: () async {
              //generate hash of image
                final img = await _imageFile;
                String hashedImage = await generateImageHash(img);
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate() ) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                saveData(firstName.text, lastName.text, birthday.text, birthplace.text, nationality.text, address.text, hashedImage);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserMenu()),
                );
              }
            },
            buttonText: "Registrieren",
            icon: Icons.check,
          ),
          ElevatedButton(
            onPressed: () {

              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserMenu()),
              );
            },
            child: Text('Skip to Profile: Debug'),
          ),

          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}

// creates album of data and sends http request to server
Future<http.Response> createAlbum(String name, String address, String birthday, String birthplace) {
  Map json = {'name': name,
              'address': address,
              'birthday': birthday,
              'birthplace': birthplace};
  print(json);
  return http.post(

    Uri.parse('http://10.0.2.2:8080/test'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: json,
  );
}

// saves data locally
Future<File> saveData(String firstName, String lastName, String birthday, String birthplace, String nationality, String address, String hashedImage) async{
  Map json = {'firstName': firstName,
              'lastName': lastName,
              'birthday': birthday,
              'birthplace': birthplace,
              'nationality': nationality,
              'address': address,
              'hashedImage': hashedImage};

  print("Input:");
  print(json);

  final file = await _localFile;

  //Write the file

  return file.writeAsString(jsonEncode(json));
}

// reads the saved data
Future<String> readData() async {
  try {
    final file = await _localFile;

    //Read the file
    final contents = await file.readAsString();
    print("Reading:");
    print(jsonDecode(contents));
    return jsonDecode(contents);
  }
  catch (e) {
    return "Not Found";
  }
}

// local path for files
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<File> get _imageFile async  {
  final path = await _localPath;
  return File('$path/image');
}


