import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DeleteRecipe {
  QueryDocumentSnapshot? snapshot;
  String? imageUrl;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  DeleteRecipe({this.snapshot, this.imageUrl});
  void deleteDocumentFromFirebase() async {
    dynamic refId = snapshot!.reference.id;
    try {
      await _firebaseFirestore
          .runTransaction((Transaction myTransaction) async {
        print("The snapshot reference is ${snapshot!.reference.id}");

        final usersCollection = _firebaseFirestore
            .collection('users')
            .where('saved', arrayContains: snapshot!.reference.id);
        final usersSnap = usersCollection.get();

        try {
          /// this will remove deleted recipe from bookmark
          await usersSnap.then(
            (value) {
              value.docs.forEach(
                (element) {
                  List tempList = element.data()['saved'];
                  // print("MY LIST IS:");
                  // print(tempList);
                  final filteredList =
                      tempList.where((element) => element != refId).toList();

                  element.reference.update({'saved': filteredList});
                },
              );
            },
          );
        } catch (e) {
          print("SAVED ITEM ERROR $e");
        }
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
