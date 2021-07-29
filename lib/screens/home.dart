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
    return SafeArea(
      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return Scaffold(
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
                        placeholder: (context, url) =>
                            Image.asset('images/profile_loading.gif'),
                        imageUrl: authProvider.auth.currentUser!.photoURL ??
                            "https://image.flaticon.com/icons/png/512/1077/1077012.png",
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
          drawer: MyDrawer(),
          body: StreamBuilder<QuerySnapshot>(
              stream: fireStore.collection('recipes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var recipes = snapshot.data!.docs;
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                              onTap: () {
                                showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate());
                              },
                              style: TextStyle(color: kDarkColor),
                              cursorColor: kPrimaryColor,
                              decoration: kSearchInputDecoration),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                              color: kOrangeColor,
                              onPressed: () {},
                              icon: Icon(
                                Icons.settings_input_component_rounded,
                                // color: myPrimaryColor,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      height: 45,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          IconWithNameCard(
                            assetImagePath: 'images/burger.png',
                            foodCategory: 'Fast Food',
                            onTap: () {
                              print('burger pressed');
                            },
                          ),
                          IconWithNameCard(
                            assetImagePath: 'images/drink.png',
                            foodCategory: 'Drinks',
                            onTap: () {
                              print('burger pressed');
                            },
                          ),
                          IconWithNameCard(
                            assetImagePath: 'images/fruit.png',
                            foodCategory: 'Fruit item',
                            onTap: () {
                              print('fruit pressed');
                            },
                          ),
                          IconWithNameCard(
                            assetImagePath: 'images/broccoli.png',
                            foodCategory: 'Vegetable',
                            onTap: () {
                              print('veg pressed');
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
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: ScreenSize.getHeight(context) * 0.45,
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
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  // color: Colors.red,
                                  width: 180,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Positioned(
                                        height: 220,
                                        width: 180,
                                        bottom: 20,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kCardColors[index % 4]
                                                .withOpacity(0.23),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: (ScreenSize.getHeight(
                                                          context) *
                                                      0.17 /
                                                      2.2),
                                                ),
                                                Text(
                                                  recipes[index]['name']
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontFamily: 'Dosis',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.45)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            size: 15,
                                                            color: Colors
                                                                .deepOrange,
                                                          ),
                                                          Text(' 4.5')
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3,
                                                              horizontal: 5),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.45)),
                                                      child: Text("easy"),
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
                                                        color: Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Expanded(
                                                  child: Text(
                                                    recipes[index]
                                                        ['description'],
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Dosis',
                                                        color: Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        height: ScreenSize.getHeight(context) *
                                            0.17,
                                        width:
                                            ScreenSize.getWidth(context) * 0.35,
                                        top: 10,
                                        child: Container(
                                          child: CachedNetworkImage(
                                            imageBuilder: (BuildContext context,
                                                imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'images/lenna.png'))),
                                              );
                                            },
                                            imageUrl: recipes[index]['photo'],
                                            placeholder:
                                                (BuildContext context, img) {
                                              return Image(
                                                image: AssetImage(
                                                    'images/profile_loading.gif'),
                                              );
                                            },
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 5),
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: InkWell(
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.favorite,
                                                    size: 15,
                                                    color: Colors.red,
                                                  ),
                                                  Text(
                                                    ' Save',
                                                    style: TextStyle(
                                                        fontFamily: 'Dosis',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }),
        );
      }),
    );
  }
}
