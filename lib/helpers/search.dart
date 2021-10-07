import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/icon_with_name_card.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'dart:async';

class CustomSearchDelegate extends SearchDelegate {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List suggestionData = [];
  Timer? _debounce;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      InkWell(
        onTap: () {
          query = '';
        },
        child: Center(
          child: Icon(
            Icons.clear,
            color: Colors.grey,
          ),
        ),
      ),
      SizedBox(
        width: 15,
      ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Search Suggestion',
              textAlign: TextAlign.start,
              style: kFormHeadingStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              children: List.generate(suggestionData.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigation.changeScreen(
                        context,
                        CookingScreen(
                          snapshot: suggestionData[index],
                        ));
                  },
                  child: SuggestionChip(
                    foodName: suggestionData[index]['name'],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print('build suggestion called');
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getSuggestionFromFirebase();
    });
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
                InkWell(
                  onTap: () {
                    Navigation.changeScreen(
                        context,
                        CookingScreen(
                          snapshot: suggestionData[index],
                        ));
                  },
                  child: Text(
                    suggestionData[index]['name'],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
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
    print('firebase called');
    var documentCollection = await fireStore.collection('recipes').get();
    suggestionData = documentCollection.docs.where((element) {
      if (element['name'].toString().toLowerCase().trim().contains(query)) {
        return true;
      } else
        return false;
    }).toList();
  }
}

class SuggestionChip extends StatelessWidget {
  final String foodName;

  SuggestionChip({this.foodName = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        border: Border.all(color: kPrimaryColor.withOpacity(0.5), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        foodName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
