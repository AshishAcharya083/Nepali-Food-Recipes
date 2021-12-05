import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/food_viewer_with_name.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'dart:core';

class BookMarkedFoodScreen extends StatefulWidget {
  final List? recipeIds;
  BookMarkedFoodScreen({this.recipeIds});

  @override
  _BookMarkedFoodScreenState createState() => _BookMarkedFoodScreenState();
}

class _BookMarkedFoodScreenState extends State<BookMarkedFoodScreen> {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Bookmarked Items',
          style: kFormHeadingStyle,
        ),
      ),
      body: widget.recipeIds!.isEmpty
          ? Center(
              child: Text(
                'No Bookmarks',
                style: kSecondaryTextStyle,
              ),
            )
          : GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0),
              itemCount: widget.recipeIds!.length,
              itemBuilder: (BuildContext ctx, index) {
                /// return InkWell here
                return StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection('recipes').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else {
                        var temp = snapshot.data!.docs;

                        /// temp will contain the list of documents which is of type QueryDocumentSnapshot
                        /// getting list of QueryDocument which matches the incoming saved document ID in tempList
                        /// this seems very inefficient way of filtering data but it's working anyway

                        var tempList = temp
                            .where((element) =>
                                element.id == widget.recipeIds![index])
                            .toList();
                        return InkWell(
                          onTap: () {
                            Navigation.changeScreen(
                                context,
                                CookingScreen(
                                  snapshot: tempList[0],
                                ));
                          },
                          child: FoodViewerWithName(
                            chefId: tempList[0]['chefId'],
                            chefImageURL: tempList[0]['chefImage'],
                            chefName: tempList[0]['chef'],
                            duration: tempList[0]['duration'],
                            foodImageURL: tempList[0]['photo'],
                            foodName: tempList[0]['name'],
                          ),
                        );
                      }
                    });
              }),
    ));
  }
}
