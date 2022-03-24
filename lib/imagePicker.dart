import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';


Future<bool> getImage(ImageSource imageSource) async {

  final ImagePicker _picker = new ImagePicker();

  // using your method of getting an image
  final XFile? image = await _picker.pickImage(source: imageSource);


  if(image == null) {
    return false;
  }

  final file = await _localFile;


// copy the file to a new path
  File tmpFile = File(image.path);
  //tmpFile = await tmpFile.copy(file.path);

  String fileName = basename(tmpFile.path);

  File copy = await tmpFile.copy(file.path);



  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profile_image', copy.path);
  print("");
  print("");
  print("");
  print("");
  print("");
  print("");
  print("ETET");
  print(tmpFile.path);
  print(prefs.getString('profile_image'));


  return true;
}


String receiveImage() {

      getPrefs().then((pref) {
        SharedPreferences prefs = pref;
        print(prefs.getString('profile_image'));
        return prefs.getString('profile_image');
      });

      print("Warum");
      return "Not Found";
}

Future getPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/image');
}