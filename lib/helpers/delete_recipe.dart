import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DeleteRecipe {
  QueryDocumentSnapshot? snapshot;
  String? imageUrl;

  DeleteRecipe({this.snapshot, this.imageUrl});
  void deleteDocumentFromFirebase() async {
    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.delete(snapshot!.reference);
      });
    } catch (e) {
      print(e);
    }

    deleteImageFromFirebase(imageUrl!);
  }

  void deleteImageFromFirebase(String url) {
    try {
      FirebaseStorage.instance.refFromURL(url).delete().then((value) {
        print('${url.substring(0, 5)} IMAGE is deleted from firebase');
      });
    } catch (e) {
      print(e);
    }
  }
}
