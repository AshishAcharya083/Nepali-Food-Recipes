import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/number_string_container.dart';
import 'package:nepali_food_recipes/components/user.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String? userID;
  Profile([this.userID]);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    print(widget.userID);
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return StreamBuilder<DocumentSnapshot>(
              stream: fireStore
                  .collection('users')
                  .doc(widget.userID == null
                      ? authProvider.auth.currentUser!.uid
                      : widget.userID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  );
                else {
                  var data = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Info(
                          imageURL: data['photo'],
                          email: data['email'],
                          name: data['name'],
                        ),
                        kFixedSizedBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            numberStringContainer(data['recipes'], 'Recipes'),
                            // numberStringContainer(
                            //     data['following'], 'following'),
                            // numberStringContainer(
                            //     data['followers'], 'followers'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                            thickness: 5,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('recipes')
                                .where('chefId',
                                    isEqualTo: widget.userID == null
                                        ? authProvider.auth.currentUser!.uid
                                        : widget.userID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                );
                              else {
                                var data = snapshot.data!.docs;

                                return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            childAspectRatio: 3.5 / 4,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 0),
                                    itemCount: data.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigation.changeScreen(
                                              context,
                                              CookingScreen(
                                                snapshot: data[index],
                                              ));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// chef name and photo

                                              SizedBox(
                                                height: 5,
                                              ),

                                              ///food image
                                              Container(
                                                height: 150,
                                                width: 150,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (BuildContext context,
                                                            photo) {
                                                      return Image(
                                                        image: AssetImage(
                                                            'images/loader.gif'),
                                                      );
                                                    },
                                                    imageUrl: data[index]
                                                        ['photo'],
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Center(
                                                                child: Icon(
                                                      Icons.network_check,
                                                      size: 35,
                                                      color: Colors.red,
                                                    )),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                // data[index]['name']
                                                data[index]['name'],
                                                overflow: TextOverflow.ellipsis,
                                                style: kFormHeadingStyle
                                                    .copyWith(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Food. ${data[index]['duration']} mins',
                                                style: kSecondaryTextStyle
                                                    .copyWith(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            })
                      ],
                    ),
                  );
                }
              });
        }),
      ),
    );
  }
}
