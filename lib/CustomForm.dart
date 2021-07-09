import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:iota_app/imagePicker.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import './loggedinprostitute.dart';
import './imagePicker.dart';
import './Buttons.dart';
import './loading_screen.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController birthplace = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.person, color: Colors.white,),
            labelText: 'Vorname, Nachname', labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white
          ),
            cursorColor: Colors.white,
            controller: name,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.home),
            labelText: 'Addresse',
          ),
            controller: address,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: 'Geburtstag',
          ),
            controller: birthday,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(decoration: const InputDecoration(
            icon: Icon(Icons.local_hospital),
            labelText: 'Geburtsort',
          ),
            controller: birthplace,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          ),
          CustomButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                saveData(name.text, address.text, birthday.text, birthplace.text);
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
          ElevatedButton(
            onPressed: () {
              getImage(ImageSource.gallery);
            },
            child: Text('Choose Picture: Debug'),
          ),
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}

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

Future<File> saveData(String name, String address, String birthday, String birthplace) async{
  Map json = {'name': name,
              'address': address,
              'birthday': birthday,
              'birthplace': birthplace};

  print("Input:");
  print(json);

  final file = await _localFile;

  //Write the file

  return file.writeAsString(jsonEncode(json));
}

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

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}


