import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/food_viewer_with_name.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/cooking.dart';

class BookMarkedFoodScreen extends StatefulWidget {
  final List? recipeIds;
  BookMarkedFoodScreen({this.recipeIds});

  @override
  _BookMarkedFoodScreenState createState() => _BookMarkedFoodScreenState();
}

class _BookMarkedFoodScreenState extends State<BookMarkedFoodScreen> {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool isLoading = true;

  List<ComponentData> compDataList = [];
  void loadData() {
    for (int i = 0; i < widget.recipeIds!.length; i++) {
      var data;
      var getData =
          _fireStore.collection('recipes').doc(widget.recipeIds![i]).get();

      getData.then((value) {
        data = value.data();

        ComponentData componentData = ComponentData(
            data['chefId'],
            data['chefImage'],
            data['chef'],
            data['name'],
            data['duration'],
            data['photo'],
            getData);

        setState(() {
          compDataList.add(componentData);
        });
        print(data['chefId']);
        print(data['description']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    print('The length of comp list is ${compDataList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Bookmarked',
          style: kFormHeadingStyle,
        ),
      ),
      body: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0),
          itemCount: compDataList.length,
          itemBuilder: (BuildContext ctx, index) {
            /// return InkWell here
            return InkWell(
              onTap: () {
                Navigation.changeScreen(
                    context,
                    CookingScreen(
                      snapshot: compDataList[index].componentSnapshot,
                    ));
              },
              child: FoodViewerWithName(
                chefId: compDataList[index].chefId,
                chefImageURL: compDataList[index].chefImageURL,
                chefName: compDataList[index].chefName,
                duration: compDataList[index].duration.toString(),
                foodImageURL: compDataList[index].foodImageURL,
                foodName: compDataList[index].foodName,
              ),
            );
          }),
    ));
  }
}

class ComponentData {
  var componentSnapshot;
  final String? chefId;
  final String? chefImageURL;
  final String? chefName;
  final String? foodName;
  final String? duration;
  final String? foodImageURL;

  ComponentData(
    this.chefId,
    this.chefImageURL,
    this.chefName,
    this.foodName,
    this.duration,
    this.foodImageURL,
    this.componentSnapshot,
  );
}
