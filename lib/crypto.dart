import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:convert';

Future<String> generateImageHash(File file) async{
  var imageBytes =  file.readAsBytesSync().toString();
  var bytes = utf8.encode(imageBytes);
  String digest = sha256.convert(bytes).toString();
  print("This is image hash :  $digest");
  return digest;
}

Future<String> generateRoot(String leafAB, String leafCD) async {
  String combined = leafAB + leafCD;
  var bytes = utf8.encode(combined);
  String digest = sha256.convert(bytes).toString();
  return digest;
}

Future<String> generateLeaf(String leafOne, String leafTwo) async {
  String combined = leafOne + leafTwo;
  var bytes = utf8.encode(combined);
  String digest = sha256.convert(bytes).toString();
  return digest;
}

Future<String> generateHash(String object) async {
  var bytes = utf8.encode(object);
  String digest = sha256.convert(bytes).toString();
  return digest;
}

Future<String> generateLeafAB(String hashImage, String firstName, String lastName, String birthplace) async {
  List tmp = [hashImage, firstName, lastName, birthplace];

  List hash = [];

  //generate individual hashes
  for(var i = 0; i < tmp.length; i++) {
    hash[i] = generateHash(tmp[i]);
  }

  //combine them
  String leafA = await generateLeaf(hash[0], hash[1]);
  String leafB = await generateLeaf(hash[2], hash[3]);

  //combine them
  String leafAB = await generateLeaf(leafA, leafB);

  return leafAB;
}

Future<String> generatLeafD(String address, String nationality) async {
  String leafD = await generateLeaf(await generateHash(address), await generateHash(nationality));
  return leafD;
}