import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';

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
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// chef name and photo
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: data[index]['chefImage'],
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'images/profile_loading.gif'),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.network_check),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        data[index]['chef'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: kPrimaryTextColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              ///food image
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          placeholder:
                                              (BuildContext context, photo) {
                                            return Image(
                                              image: AssetImage(
                                                  'images/loader.gif'),
                                            );
                                          },
                                          imageUrl: data[index]['photo'],
                                          errorWidget: (context, url, error) =>
                                              Center(
                                                  child: Icon(
                                            Icons.network_check,
                                            size: 35,
                                            color: Colors.red,
                                          )),
                                        ),
                                      ),

                                      /// add to fav button
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                            padding: EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Icon(
                                              Icons.favorite_border_outlined,
                                              color: Colors.white,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  data[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      kFormHeadingStyle.copyWith(fontSize: 18),
                                ),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),

                              Expanded(
                                child: Text(
                                  'Food. ${data[index]['duration']} mins',
                                  style: kSecondaryTextStyle.copyWith(
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
