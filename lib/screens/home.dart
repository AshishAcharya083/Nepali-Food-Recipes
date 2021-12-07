import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nepali_food_recipes/components/icon_with_name_card.dart';
import 'package:nepali_food_recipes/components/my_drawer.dart';
import 'package:nepali_food_recipes/components/user.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/helpers/search.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'package:nepali_food_recipes/screens/food_category_screen.dart';
import 'package:nepali_food_recipes/screens/profile.dart';
import 'package:nepali_food_recipes/screens/recipe_form.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum Category { fastFood, fruitItem, vegetable }

class _HomePageState extends State<HomePage> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Category? _category;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Are you sure want to quit?',
              ),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      'Yes',
                      style: kFormHeadingStyle.copyWith(
                          fontSize: 16, color: Colors.red),
                    ),
                    onPressed: () => Navigator.of(context).pop(true)),
                TextButton(
                    child: Text(
                      'cancel',
                      style: kFormHeadingStyle.copyWith(fontSize: 16),
                    ),
                    onPressed: () => Navigator.of(context).pop(false)),
              ],
            );
          },
        );

        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child:
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
            if (authProvider.auth.currentUser != null)
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigation.changeScreen(context, Profile());
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  authProvider.auth.currentUser!.photoURL!,
                              placeholder: (context, url) => Image.asset(
                                'images/profile_loading.gif',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.white,
                                child: Center(
                                    child: Icon(
                                  Icons.network_check,
                                  size: 35,
                                  color: Colors.red,
                                )),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: BoxDecoration(
                              // image: DecorationImage(
                              //     image: AssetImage('images/lenna.png'),
                              //     fit: BoxFit.cover),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                drawer: MyDrawer(context),
                body: StreamBuilder<QuerySnapshot>(
                  stream: fireStore
                      .collection('recipes')
                      .orderBy('views', descending: true)
                      .where(
                        'status',
                        isEqualTo: 'approved',
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      );
                    var recipes = snapshot.data!.docs;
                    if (recipes.length < 1) {
                      return Center(
                        child: Text(
                          "Nothing to show",
                        ),
                      );
                    } else
                      return ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(left: 10),
                        children: [
                          Text(
                            'Nepali Food \nRecipes 😋',
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              fontWeight: FontWeight.bold,
                              // color: kPrimaryTextColor,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          /// search bar
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextField(
                                onChanged: (string) {
                                  showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate());
                                },
                                onTap: () {
                                  showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate());
                                },
                                style: TextStyle(color: kDarkColor),
                                cursorColor: kPrimaryColor,
                                decoration: kSearchInputDecoration),
                          ),
                          SizedBox(
                            height: 18,
                          ),

                          /// chip tiles for categories
                          Container(
                            height: 45,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                IconWithNameCard(
                                  assetImagePath: 'images/burger.png',
                                  foodCategory: 'Fast Food',
                                  onTap: () {
                                    Navigation.changeScreen(
                                      context,
                                      FoodCategoryScreen(
                                        imagePath: 'images/burger.png',
                                        foodCategory: 'Fast Food',
                                      ),
                                    );
                                  },
                                ),
                                IconWithNameCard(
                                  assetImagePath: 'images/drink.png',
                                  foodCategory: 'Drinks',
                                  onTap: () {
                                    Navigation.changeScreen(
                                        context,
                                        FoodCategoryScreen(
                                          imagePath: 'images/drink.png',
                                          foodCategory: 'Drinks',
                                        ));
                                  },
                                ),
                                IconWithNameCard(
                                  assetImagePath: 'images/fruit.png',
                                  foodCategory: 'Fruit item',
                                  onTap: () {
                                    Navigation.changeScreen(
                                        context,
                                        FoodCategoryScreen(
                                          imagePath: 'images/fruit.png',
                                          foodCategory: 'Fruit',
                                        ));
                                  },
                                ),
                                IconWithNameCard(
                                  assetImagePath: 'images/broccoli.png',
                                  foodCategory: 'Veg',
                                  onTap: () {
                                    Navigation.changeScreen(
                                        context,
                                        FoodCategoryScreen(
                                          imagePath: 'images/broccoli.png',
                                          foodCategory: 'Veg',
                                        ));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Top Recipes',
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: 24,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 330,

                            ///most outer container's height
                            // height: ScreenSize.getHeight(context) * 0.45,
                            child: ListView.builder(
                              itemCount: recipes.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigation.changeScreen(
                                      context,
                                      CookingScreen(
                                        snapshot: snapshot.data!.docs[index],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      // color: Colors.red,
                                      width: 180,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          /// container having name and description
                                          Positioned(
                                            height: 220,
                                            width: 180,
                                            top: 80,
                                            // bottom: 20,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        kCardColors[index % 4]
                                                            .withOpacity(0.1),
                                                    width: 3),
                                                color: kCardColors[index % 4]
                                                    .withOpacity(0.23),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    SizedBox(height: 50),
                                                    Text(
                                                      recipes[index]['name']
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: 'Dosis',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.45)),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                size: 15,
                                                                color: Colors
                                                                    .deepOrange,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(recipes[
                                                                          index]
                                                                      ['views']
                                                                  .toString())
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      5),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.45)),

                                                          /// difficulty of recipe
                                                          child: Text(
                                                              recipes[index]
                                                                      ['isEasy']
                                                                  ? 'Easy'
                                                                  : 'Hard'),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                        '⏱  ' +
                                                            recipes[index]
                                                                    ['duration']
                                                                .toString() +
                                                            ' min',
                                                        style: TextStyle(
                                                            fontFamily: 'Dosis',
                                                            color:
                                                                Colors.blueGrey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    Expanded(
                                                      child: Text(
                                                        recipes[index]
                                                            ['description'],
                                                        maxLines: 4,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontFamily: 'Dosis',
                                                            color:
                                                                Colors.blueGrey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          ///food image
                                          Positioned(
                                            right: 10,
                                            height: 140,
                                            width: 140,
                                            // height:
                                            //     ScreenSize.getHeight(context) *
                                            //         0.17,

                                            // width:
                                            //     ScreenSize.getWidth(context) *
                                            //         0.35,
                                            top: 0,
                                            child: Container(
                                              child: CachedNetworkImage(
                                                imageBuilder:
                                                    (BuildContext context,
                                                        imageProvider) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover)),
                                                  );
                                                },
                                                imageUrl: recipes[index]
                                                    ['photo'],
                                                placeholder:
                                                    (BuildContext context,
                                                        img) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'images/loader.gif'),
                                                            fit: BoxFit.cover)),
                                                  );
                                                },
                                                errorWidget:
                                                    (BuildContext context, img,
                                                        dyn) {
                                                  return Icon(
                                                    Icons.network_check,
                                                    size: 35,
                                                  );
                                                },
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: kCardColors[
                                                                index % 4]
                                                            .withOpacity(0.4),
                                                        blurRadius: 12,
                                                        offset: Offset(4, 4),
                                                        spreadRadius: 0)
                                                  ],
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 5),
                                                  // color: Colors.red,
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            bottom: 18,
                                            child: InkWell(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: kCardColors[
                                                                  index % 4]
                                                              .withOpacity(0.4),
                                                          blurRadius: 12,
                                                          offset: Offset(4, 4),
                                                          spreadRadius: 0)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white),
                                                child: Text(
                                                  recipes[index]['veg']
                                                      ? 'veg'
                                                      : 'non-Veg',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            'Recipe of The day',
                            style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold),
                          ),

                          InkWell(
                            onTap: () {
                              Navigation.changeScreen(
                                  context,
                                  CookingScreen(
                                    snapshot: recipes[recipes.length >= 32
                                        ? recipes.length -
                                            DateTime.now().day.toInt()
                                        : (recipes.length < 6
                                            ? 1
                                            : DateTime.now().weekday)],
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 15, right: 15, bottom: 15, left: 10),
                              height: ScreenSize.getWidth(context) * 0.5,
                              width: ScreenSize.getWidth(context) * 0.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: recipes[0]["photo"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        ],
                      );
                  },
                ),
              );
            else
              return Scaffold(
                body: Center(
                  child: Text('No user detected'),
                ),
              );
          }),
        ),
      ),
    );
  }
}
