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
          TextFormField(decoration: InputDecoration(
            icon: Icon(Icons.person, color: Colors.white,),
            labelText: AppLocalizations.of(context)!.firstName, labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white
          ),
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.white,
            controller: firstName,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.obligatoryField;
              }
              return null;
            },
          ),
          TextFormField(decoration: InputDecoration(
            icon: Icon(Icons.account_circle_outlined, color: Colors.white,),
            labelText: AppLocalizations.of(context)!.lastName, labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white
          ),
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.white,
            controller: lastName,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.obligatoryField;
              }
              return null;
            },
          ),
          TextFormField(decoration: InputDecoration(
            icon: Icon(Icons.calendar_today, color: Colors.white,),
            labelText: AppLocalizations.of(context)!.birthday,labelStyle: TextStyle(color: Colors.white),
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
                return AppLocalizations.of(context)!.obligatoryField;
              }
              return null;
            },
          ),
          TextFormField(decoration: InputDecoration(
            icon: Icon(Icons.local_hospital, color: Colors.white,),
            labelText: AppLocalizations.of(context)!.birthplace,labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white
          ),
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.white,
            controller: birthplace,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.obligatoryField;
              }
              return null;
            },
          ),
          TextFormField(decoration: InputDecoration(
              icon: Icon(Icons.flag_outlined, color: Colors.white,),
              labelText: AppLocalizations.of(context)!.nationality,labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white
          ),
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.white,
            controller: nationality,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.obligatoryField;
              }
              return null;
            },
          ),
          TextFormField(decoration: InputDecoration(
            icon: Icon(Icons.house_outlined, color: Colors.white,),
            labelText: AppLocalizations.of(context)!.address,labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              focusColor: Colors.white,
            hintText: AppLocalizations.of(context)!.addressForm
          ),
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.white,
            controller: address,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.obligatoryField;
              }
              return null;
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
          ),
          CustomButton(
            onPressed: () {
              getImage(ImageSource.gallery).then((value) => setState(() {
                if(value) {
                  image = true;
                }
              }));

            },
            buttonText: AppLocalizations.of(context)!.chooseImage,
            icon: Icons.image
          ),
          if(!image)
          Text(AppLocalizations.of(context)!.imageInformation, style: TextStyle(color: Colors.white),),
          if(!image)
            Text(AppLocalizations.of(context)!.imageWarning, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          if(image)
            Text(AppLocalizations.of(context)!.imageSuccess, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 80, bottom: 0),
          ),
          CustomButton(
            onPressed: () async {

              bool flag = false;

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
                    Text("Make sure the data is as your ID shows.",textAlign: TextAlign.center,),
                    Container(padding: EdgeInsets.all(10),),
                    Text("You cannot change the data after the registration, without invalidating your certificates!", textAlign: TextAlign.center,),
                    Container(padding: EdgeInsets.all(10),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(onPressed: () {

                          Navigator.of(context).pop();

                          flag = true;
                        }, buttonText: "Register", icon: Icons.check),
                        Container(padding: EdgeInsets.all(10),),
                        Expanded(child:
                        CustomButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, buttonText: "Edit Data", icon: Icons.cancel),),
                      ],
                    )

                  ],
                )


                ]
                ));
              });


            if(flag) {
              //generate hash of image
                final img = await _imageFile;
                String hashedImage = "";
                try {
                  hashedImage = await generateImageHash(img);
                }
                catch (error) {
                  setState(() {
                    image = false;
                  });
                  return;
                }
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate() ) {

                saveData(firstName.text, lastName.text, birthday.text, birthplace.text, nationality.text, address.text, hashedImage);

                Navigator.of(context).pop();

              }
              }
            },
            buttonText: AppLocalizations.of(context)!.registrationPage,
            icon: Icons.check,
          ),
          /*ElevatedButton(
            onPressed: () {

              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserMenu()),
              );
            },
            child: Text('Skip to Profile: Debug'),
          ),*/

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


