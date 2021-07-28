import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:timelines/timelines.dart';

class CookingScreen extends StatefulWidget {
  QueryDocumentSnapshot? snapshot;
  CookingScreen({this.snapshot});

  @override
  _CookingScreenState createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  var recipeDetail;
  String foodName = 'Food Name';
  String cookingDuration = '30';
  String description = 'Taste of Asia';
  List ingredients = ['butter', 'chilli'];
  List steps = ['fry', ' cook it 15 minutes'];
  bool isVeg = false;
  String? imgUrl;
  @override
  void initState() {
    super.initState();

    recipeDetail = widget.snapshot;
    foodName = recipeDetail['name'];
    cookingDuration = recipeDetail['duration'].toString();
    description = recipeDetail['description'];
    ingredients = recipeDetail['ingredients'];
    steps = recipeDetail['steps'];
    isVeg = recipeDetail['veg'];
    imgUrl = recipeDetail['photo'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(top: 10),
                title: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /// food title
                      Text(
                        foodName,
                        style: kFormHeadingStyle.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                collapseMode: CollapseMode.parallax,
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          imgUrl!,
                        ),
                        fit: BoxFit.cover),
                  ),
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kFixedSizedBox,
                  Text(
                    '${isVeg ? 'Veg' : 'Non-veg'}. ${cookingDuration.toString()} mins',
                    style: kSecondaryTextStyle,
                  ),
                  kFixedSizedBox,
                  kDivider,
                  Text(
                    'Description',
                    style: kFormHeadingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    description,
                    style: kSecondaryTextStyle,
                  ),
                  kDivider,
                  Text(
                    'Ingredients',
                    style: kFormHeadingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ])),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  ingredients.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.1)),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          ingredients[index],
                          style: TextStyle(
                              fontFamily: 'Dosis-SemiBold', letterSpacing: 1.1),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Steps',
                style: kFormHeadingStyle,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FixedTimeline.tileBuilder(
                  theme: TimelineThemeData(
                    nodePosition: 0.04,
                    color: Colors.red,
                    indicatorTheme: IndicatorThemeData(
                      position: 0.5,
                      size: 20.0,
                    ),
                    connectorTheme: ConnectorThemeData(
                      color: kPrimaryColor,
                      thickness: 4,
                    ),
                  ),
                  mainAxisSize: MainAxisSize.max,
                  builder: TimelineTileBuilder.connectedFromStyle(
                    oppositeContentsBuilder: (context, index) => Container(
                      width: 5,
                    ),
                    contentsAlign: ContentsAlign.basic,
                    contentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(5, 5))
                            ]),
                        child: Text(
                          steps[index],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ),
                    connectorStyleBuilder: (context, index) =>
                        ConnectorStyle.solidLine,
                    indicatorStyleBuilder: (context, index) =>
                        IndicatorStyle.outlined,
                    itemCount: steps.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
