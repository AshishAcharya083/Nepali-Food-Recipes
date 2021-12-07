import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/food_viewer_with_name.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'dart:core';

class NewestItemsScreen extends StatefulWidget {
  @override
  _NewestItemsScreenState createState() => _NewestItemsScreenState();
}

class _NewestItemsScreenState extends State<NewestItemsScreen> {
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
            'Newest Items',
            style: kFormHeadingStyle,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _fireStore
                .collection('recipes')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              var temp = snapshot.data!.docs;
              if (temp.length < 1)
                return Center(
                  child: Text("no items to show"),
                );
              else
                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 0),
                  itemCount: temp.length > 14 ? 15 : temp.length,
                  itemBuilder: (BuildContext ctx, index) {
                    /// return InkWell here

                    return InkWell(
                      onTap: () {
                        Navigation.changeScreen(
                          context,
                          CookingScreen(
                            snapshot: temp[index],
                          ),
                        );
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
                  },
                );
            }),
      ),
    );
  }
}
