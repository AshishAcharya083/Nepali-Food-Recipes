import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadAndGetImageURL(XFile image, String title) async {
  var tempName = DateTime.now().millisecond.toString().substring(0, 2).trim();
  String finalPath = title + tempName + '.jpg';
  File myImage = File(image.path);
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var url;
  final firebaseStorageRef = firebaseStorage
      .ref('/images')
      .child(finalPath.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
  try {
    final uploadTask = await firebaseStorageRef
        .putFile(myImage)
        .then((sth) => {print('uploaded')})
        .whenComplete(() {
      url = firebaseStorageRef.getDownloadURL();
      return url;
    });
  } catch (e) {
    print(e);
  }
  return url;
}
