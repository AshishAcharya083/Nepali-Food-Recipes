import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/my_drawer.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'dart:core';
import 'package:nepali_food_recipes/helpers/search.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/bookmarked_foods.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'package:nepali_food_recipes/screens/newest_item_screen.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      double value = controller.offset / 170;

      ///(150 + 20)*1 => (totalH + verticalMargin)* height factor

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: fireStore
                .collection('recipes')
                .where('status', isEqualTo: 'approved')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              var docs = snapshot.data!.docs;

              return Container(
                height: size.height,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: TextField(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: CustomSearchDelegate());
                        },
                        decoration: kSearchInputDecoration,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: closeTopContainer ? 0 : 1,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: size.width,
                          alignment: Alignment.topCenter,
                          height: closeTopContainer ? 0 : categoryHeight,
                          child: categoriesScroller),
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: docs.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              double scale = 1.0;
                              if (topContainer > 0.5) {
                                scale = index + 0.5 - topContainer;

                                if (scale < 0) {
                                  scale = 0;
                                } else if (scale > 1) {
                                  scale = 1;
                                }
                              }

                              return Opacity(
                                opacity: scale,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigation.changeScreen(
                                        context,
                                        CookingScreen(
                                          snapshot: docs[index],
                                        ));
                                  },
                                  child: Transform(
                                    transform: Matrix4.identity()
                                      ..scale(scale, scale),
                                    alignment: Alignment.bottomCenter,
                                    child: Align(
                                      heightFactor: 1,
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        height: 150,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  spreadRadius: 0,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 5))
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: FadeInImage(
                                                      imageErrorBuilder:
                                                          (BuildContext context,
                                                              obj, trace) {
                                                        return Icon(
                                                          Icons.network_check,
                                                          size: 35,
                                                          color: Colors.red,
                                                        );
                                                      },
                                                      placeholder: AssetImage(
                                                          'images/loader.gif'),
                                                      image: NetworkImage(
                                                          docs[index]['photo']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      Text(
                                                        docs[index]['name']
                                                            .toString()
                                                            .toUpperCase(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: kFormHeadingStyle
                                                            .copyWith(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .access_time_filled,
                                                            size: 20,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                          Text(
                                                            ' ' +
                                                                docs[index][
                                                                        'duration']
                                                                    .toString() +
                                                                ' min.',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('Difficulty: '),
                                                          Text(
                                                            docs[index]['isEasy']
                                                                        .toString() ==
                                                                    'true'
                                                                ? 'EASY'
                                                                : 'HARD',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('Type: '),
                                                          Text(
                                                            docs[index]['veg']
                                                                        .toString() ==
                                                                    'true'
                                                                ? 'VEG'
                                                                : 'NON-VEG',
                                                            style: TextStyle(
                                                                color: docs[index]['veg']
                                                                            .toString() ==
                                                                        'true'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class CategoriesScroller extends StatefulWidget {
  @override
  State<CategoriesScroller> createState() => _CategoriesScrollerState();
}

class _CategoriesScrollerState extends State<CategoriesScroller> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<DocumentSnapshot>(
          stream: fireStore
              .collection('users')
              .doc(Provider.of<AuthProvider>(context, listen: false)
                  .auth
                  .currentUser!
                  .uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            else {
              var data = snapshot.data!['saved'];
              print(data);
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigation.changeScreen(
                              context,
                              BookMarkedFoodScreen(
                                recipeIds: data,
                              ));
                        },
                        child: Container(
                          width: 150,
                          margin: EdgeInsets.only(right: 20),
                          height: categoryHeight,
                          decoration: BoxDecoration(
                              color: Colors.orange.shade400,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Saved\nItems",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${data.length} items',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigation.changeScreen(context, NewestItemsScreen());
                        },
                        child: Container(
                          width: 150,
                          margin: EdgeInsets.only(right: 20),
                          height: categoryHeight,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Newest\nItems",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "20 Items",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
