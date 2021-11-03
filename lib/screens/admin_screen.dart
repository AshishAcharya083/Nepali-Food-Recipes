import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/flat_button.dart';
import 'package:nepali_food_recipes/components/snack_bar.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/delete_recipe.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Admin Control',
            style: kFormHeadingStyle,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: fireStore
                .collection('recipes')
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Text('No Data'),
                );
              var data = snapshot.data!.docs;
              // print(snapshot.data!.docs[0].runtimeType);
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onTap: () {
                        Navigation.changeScreen(
                          context,
                          CookingScreen(
                            snapshot: data[index],
                          ),
                        );
                      },
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: FadeInImage(
                                      imageErrorBuilder:
                                          (BuildContext context, obj, trace) {
                                        return Icon(
                                          Icons.network_check,
                                          size: 35,
                                          color: Colors.red,
                                        );
                                      },
                                      placeholder:
                                          AssetImage('images/loader.gif'),
                                      image: NetworkImage(data[index]['photo']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          data[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: kFormHeadingStyle.copyWith(
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          ScreenSize.getHeight(context) * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            try {
                                              fireStore
                                                  .collection('recipes')
                                                  .doc(data[index].id)
                                                  .set({
                                                'status': 'approved'
                                              }, SetOptions(merge: true)).then(
                                                      (value) {
                                                showSnackBar('Approved',
                                                    context, Icons.done);
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: SmallButtonWithText(
                                            buttonInsidePadding: 10,
                                            text: 'Accept',
                                            color: Colors.green.shade400,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print('Delete Recipe tapped');
                                            DeleteRecipe(
                                                    snapshot: data[index],
                                                    imageUrl: data[index]
                                                        ['photo'])
                                                .deleteDocumentFromFirebase();
                                          },
                                          child: SmallButtonWithText(
                                            buttonInsidePadding: 10,
                                            text: 'reject',
                                            color: Colors.red.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          ScreenSize.getHeight(context) * 0.02,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'By: ',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: kFormHeadingStyle.copyWith(
                                                fontSize: 15),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data[index]['chef'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: kFormHeadingStyle.copyWith(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

class SmallButtonWithText extends StatelessWidget {
  final String text;
  final Color color;
  final double buttonInsidePadding;
  const SmallButtonWithText(
      {this.text = 'Button',
      this.color = kPrimaryColor,
      this.buttonInsidePadding = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: buttonInsidePadding, vertical: buttonInsidePadding - 3),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
    );
  }
}
