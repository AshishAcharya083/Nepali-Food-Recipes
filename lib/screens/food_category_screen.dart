import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/food_viewer_with_name.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'package:nepali_food_recipes/screens/profile.dart';

class FoodCategoryScreen extends StatefulWidget {
  final String? imagePath;
  final String? foodCategory;
  FoodCategoryScreen({this.imagePath, this.foodCategory});

  @override
  _FoodCategoryScreenState createState() => _FoodCategoryScreenState();
}

class _FoodCategoryScreenState extends State<FoodCategoryScreen> {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ScreenSize.getHeight(context) * 0.15),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              height: ScreenSize.getHeight(context) * 0.15,
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: kPrimaryTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(widget.imagePath!))),
                      ),
                    ),
                    Text(
                      widget.foodCategory!,
                      style: kFormHeadingStyle,
                    )
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _fireStore
                .collection('recipes')
                .where('category', isEqualTo: widget.foodCategory)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              else {
                final data = snapshot.data!.docs;

                /// sample to retrieve data

                // data[index]['chefId']
                if (data.length < 1) {
                  return Center(
                    child: Text('No Items'),
                  );
                } else
                  return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 0),
                      itemCount: data.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            Navigation.changeScreen(
                                context,
                                CookingScreen(
                                  snapshot: data[index],
                                ));
                          },
                          child: FoodViewerWithName(
                            chefId: data[index]['chefId'],
                            chefImageURL: data[index]['chefImage'],
                            chefName: data[index]['chef'],
                            duration: data[index]['duration'].toString(),
                            foodImageURL: data[index]['photo'],
                            foodName: data[index]['name'],
                          ),
                        );
                      });
              }
            }),
      ),
    );
  }
}
