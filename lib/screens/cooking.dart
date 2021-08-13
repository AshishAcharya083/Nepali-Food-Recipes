import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/snack_bar.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class CookingScreen extends StatefulWidget {
  final QueryDocumentSnapshot? snapshot;
  CookingScreen({this.snapshot});

  @override
  _CookingScreenState createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List<IndicatorStyle> indicatorValues = [
    IndicatorStyle.outlined,
    IndicatorStyle.dot
  ];
  var recipeDetail;
  String foodName = 'Food Name';
  String cookingDuration = '30';
  String description = 'Taste of Asia';
  List ingredients = ['butter', 'chilli'];
  List steps = ['fry', ' cook it 15 minutes'];
  bool isVeg = false;
  String chefName = '';
  String? chefImage;
  String? imgUrl;
  int? views;
  String? docRefId;
  bool isSaved = false;
  @override
  void initState() {
    super.initState();

    docRefId = widget.snapshot!.reference.id;

    recipeDetail = widget.snapshot;
    foodName = recipeDetail['name'];
    cookingDuration = recipeDetail['duration'].toString();
    description = recipeDetail['description'];
    ingredients = recipeDetail['ingredients'];
    steps = recipeDetail['steps'];
    isVeg = recipeDetail['veg'];
    imgUrl = recipeDetail['photo'];
    chefName = recipeDetail['chef'];
    chefImage = recipeDetail['chefImage'];
    views = recipeDetail['views'];

    increaseViewCount(docRefId!);
    checkIfAlreadySavedOrNot();
  }

  void removeFromBookmark() {
    print('remove called');
    _fireStore
        .collection('users')
        .doc(Provider.of<AuthProvider>(context, listen: false)
            .auth
            .currentUser!
            .uid)
        .update({
      'saved': FieldValue.arrayRemove([docRefId])
    }).onError((error, stackTrace) {
      showSnackBar('Cannot remove from bookmark', context);
    });

    setState(() {
      isSaved = false;
    });
  }

  void checkIfAlreadySavedOrNot() {
    _fireStore
        .collection('users')
        .doc(Provider.of<AuthProvider>(context, listen: false)
            .auth
            .currentUser!
            .uid)
        .get()
        .then(
          (value) => {
            if (value['saved'].contains(docRefId))
              setState(() {
                isSaved = true;
              })
            else
              setState(() {
                isSaved = false;
              })
          },
        );
  }

  void increaseViewCount(String docId) {
    _fireStore
        .collection('recipes')
        .doc(docId)
        .set({'views': views! + 1}, SetOptions(merge: true));
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
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          foodName,
                          textAlign: TextAlign.center,
                          style:
                              kFormHeadingStyle.copyWith(color: Colors.white),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                collapseMode: CollapseMode.parallax,

                /// food image
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
                  Row(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: chefImage!,
                            placeholder: (context, url) =>
                                Image.asset('images/profile_loading.gif'),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.network_check),
                            fit: BoxFit.cover,
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          chefName,
                          overflow: TextOverflow.ellipsis,
                          style: kFormHeadingStyle.copyWith(fontSize: 15),
                        ),
                      ),
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.red,
                      ),
                      Text(
                        '  $views views',
                        style: kFormHeadingStyle.copyWith(fontSize: 15),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: isSaved
                        ? () {
                            removeFromBookmark();
                          }
                        : () async {
                            print('save clicked');
                            _fireStore
                                .collection('users')
                                .doc(Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .auth
                                    .currentUser!
                                    .uid)
                                .update(
                              {
                                'saved': FieldValue.arrayUnion([docRefId])
                              },
                            ).onError((error, stackTrace) {
                              print(error);
                              showSnackBar(
                                  'Could not Save at the moment', context);
                            });
                            setState(() {
                              isSaved = true;
                            });
                          },
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(isSaved ? 'Bookmarked' : 'Bookmark',
                              style: kFormHeadingStyle.copyWith(fontSize: 15))
                        ],
                      ),
                    ),
                  ),
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
                ListView.builder(
                  itemCount: steps.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return TimelineTile(
                      // oppositeContents: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('opposite\ncontents'),
                      // ),

                      nodePosition: 0.05,
                      contents: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: ScreenSize.getWidth(context),
                          padding: EdgeInsets.all(25),
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 1.5),
                          ),
                        ),
                      ),
                      node: TimelineNode(
                        indicator: ContainerIndicator(
                          child: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: 18,
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        startConnector: SolidLineConnector(
                          color: index == 0
                              ? Colors.transparent
                              : kLightGreenColor,
                          thickness: 3.5,
                        ),
                        endConnector: SolidLineConnector(
                          color: (index + 1) == steps.length
                              ? Colors.transparent
                              : kLightGreenColor,
                          thickness: 3.5,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
