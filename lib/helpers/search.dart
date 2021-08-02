import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';

class CustomSearchDelegate extends SearchDelegate {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List suggestionData = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image: AssetImage('images/recipe-book.png'),
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
    return Column(
      children: [Text('result')],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getSuggestionFromFirebase();
    return ListView.builder(
        itemCount: suggestionData.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  suggestionData[index]['name'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
    // throw UnimplementedError();
  }

  Future getSuggestionFromFirebase() async {
    var documentCollection = await fireStore.collection('recipes').get();
    suggestionData = documentCollection.docs.where((element) {
      if (element['name'].toString().toLowerCase().trim().contains(query)) {
        return true;
      } else
        return false;
    }).toList();
  }
}
