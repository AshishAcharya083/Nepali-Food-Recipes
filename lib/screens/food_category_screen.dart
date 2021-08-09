import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';

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
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// chef name and photo
                            Row(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      fit: BoxFit.cover,
                                      height: 35,
                                      width: 35,
                                      image: CachedNetworkImageProvider(
                                          data[index]['chefImage']),
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
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 150,
                              width: 150,
                              child: Stack(
                                children: [
                                  /// food image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      image: AssetImage('images/lenna.png'),
                                    ),
                                  ),

                                  /// add to fav button
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.5),
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
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Pancake Ashish Acharya ',
                              overflow: TextOverflow.ellipsis,
                              style: kFormHeadingStyle.copyWith(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Food. >60 mins',
                              style: kSecondaryTextStyle.copyWith(fontSize: 12),
                            )
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
