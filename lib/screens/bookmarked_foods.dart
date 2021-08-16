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
          'Bookmarked',
          style: kFormHeadingStyle,
        ),
      ),
      body: GridView.builder(
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

                    /// temp will contain the list of documents which is of type QueryDocument Snapshot
                    ///
                    return InkWell(
                      onTap: () {
                        Navigation.changeScreen(
                            context,
                            CookingScreen(
                              snapshot: temp[index],
                            ));
                      },
                      child: FoodViewerWithName(
                        chefId: temp[index]['chefId'],
                        chefImageURL: temp[index]['chefImage'],
                        chefName: temp[index]['chef'],
                        duration: temp[index]['duration'],
                        foodImageURL: temp[index]['photo'],
                        foodName: temp[index]['name'],
                      ),
                    );
                  }
                });
          }),
    ));
  }
}
