import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/flat_button.dart';
import 'package:nepali_food_recipes/components/toggle_box.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/firebase_storage.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RecipeForm extends StatefulWidget {
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  List<String> ingredients = ['', ''];
  List<String> steps = ['', '', ''];
  String? errorText;
  double cookTime = 20;
  XFile? image;
  ImagePicker _picker = ImagePicker();
  String? imageUrl;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _foodNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? imageFile;
  bool isVeg = false;
  String category = 'Casual';
  List<bool> categoryBool = [false, false, false, true];

  @override
  void initState() {
    super.initState();
  }

  void imagePicker(ImageSource source, BuildContext context) async {
    var temp = await _picker.pickImage(source: source);
    setState(() {
      image = temp;
      imageFile = File(temp!.path);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(ingredients);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Image(
                    // height: 0,
                    alignment: Alignment.bottomCenter,
                    image: AssetImage('images/book.png'),
                  ),
                  Text(
                    'Publish Your Own\nRecipe.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: kPrimaryTextColor),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  await alertDialog(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 180,
                  width: ScreenSize.getWidth(context),
                  child: imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('images/gallery.png')),
                            Text(
                              'Add Cover Photo',
                              style: kFormHeadingStyle.copyWith(fontSize: 18),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Text(
                'Food name',
                style: kFormHeadingStyle,
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _foodNameController,
                style: kTextFieldStyle,
                decoration:
                    kTextFieldInputDecoration(hintText: 'Enter Food Name'),
              ),
              kFixedSizedBox,
              Text(
                'Food type',
                style: kFormHeadingStyle,
              ),

              Center(
                heightFactor: 1.3,
                child: ToggleButtons(
                    borderRadius: BorderRadius.circular(20),
                    // splashColor: kPrimaryColor,
                    children: [
                      ToggleBoxButton(
                        title: 'Veg',
                        imgPath: 'images/broccoli.png',
                        width: ScreenSize.getWidth(context) * 0.35,
                      ),
                      ToggleBoxButton(
                        width: ScreenSize.getWidth(context) * 0.35,
                        title: 'Non-veg',
                        imgPath: 'images/meat.png',
                      ),
                    ],
                    isSelected: [isVeg, !isVeg],
                    onPressed: (a) {
                      if (a == 0)
                        setState(() {
                          isVeg = true;
                        });
                      else
                        setState(() {
                          isVeg = false;
                        });
                    },

                    // renderBorder: false,
                    fillColor: isVeg ? kLightGreenColor : Colors.redAccent),
              ),

              Text(
                'Category',
                style: kFormHeadingStyle,
              ),
              Center(
                heightFactor: 1.3,
                child: ToggleButtons(
                  fillColor: kPrimaryColor,
                  isSelected: categoryBool,
                  borderRadius: BorderRadius.circular(20),
                  onPressed: (b) {
                    setState(() {
                      categoryBool.setAll(0, [false, false, false, false]);
                      categoryBool[b] = true;
                    });
                    switch (b) {
                      case 0:
                        setState(() {
                          category = 'Fast Food';
                        });
                        break;
                      case 1:
                        setState(() {
                          category = 'Drinks';
                        });
                        break;
                      case 2:
                        setState(() {
                          category = 'Fruit';
                        });
                        break;
                      case 3:
                        setState(() {
                          category = 'casual';
                        });
                        break;
                    }
                    print(categoryBool);
                  },
                  children: [
                    ToggleBoxButton(
                        width: ScreenSize.getWidth(context) * 0.25,
                        title: 'Fast Food',
                        imgPath: 'images/burger.png'),
                    ToggleBoxButton(
                        width: ScreenSize.getWidth(context) * 0.2,
                        title: 'Drink',
                        imgPath: 'images/drink.png'),
                    ToggleBoxButton(
                        width: ScreenSize.getWidth(context) * 0.2,
                        title: 'Fruit',
                        imgPath: 'images/fruit.png'),
                    ToggleBoxButton(
                        width: ScreenSize.getWidth(context) * 0.2,
                        title: 'Casual',
                        imgPath: 'images/casual-food.png')
                  ],
                ),
              ),
              Text(
                'Description',
                style: kFormHeadingStyle,
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _descriptionController,
                style: kTextFieldStyle,
                maxLines: 3,
                decoration: kTextFieldInputDecoration(
                    hintText: 'Tell us little more about food'),
              ),
              kFixedSizedBox,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Cooking Duration',
                      style: kFormHeadingStyle.copyWith(fontFamily: 'Dosis'),
                    ),
                    TextSpan(
                        text: ' (in minutes)',
                        style: kFormHeadingStyle.copyWith(
                            color: Colors.grey,
                            fontFamily: 'Dosis',
                            fontSize: 16,
                            letterSpacing: 1.2))
                  ],
                ),
              ),

              /// slider
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '<10',
                          style: kSliderText.copyWith(color: kPrimaryColor),
                        ),
                        Text('30',
                            style: cookTime > 24
                                ? kSliderText.copyWith(color: kPrimaryColor)
                                : kSliderText),
                        Text(
                          '50',
                          style: cookTime > 40
                              ? kSliderText.copyWith(color: kPrimaryColor)
                              : kSliderText,
                        ),
                        Text(
                          '>60',
                          style: cookTime > 55
                              ? kSliderText.copyWith(color: kPrimaryColor)
                              : kSliderText,
                        )
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: sliderThemeData(context),
                    child: Slider(
                      label: "$cookTime",
                      max: 60,
                      min: 10,
                      value: cookTime,
                      onChanged: (newCookingTime) => setState(
                        () {
                          cookTime = newCookingTime;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Ingredients',
                style: kFormHeadingStyle,
              ),
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CircleAvatar(
                                child: Text((index + 1).toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                backgroundColor: kLightGreenColor,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: kTextFieldInputDecoration(
                                    errorText: errorText),
                                controller: TextEditingController(
                                    text: ingredients[index]),
                                style: kTextFieldStyle,
                                onChanged: (value) {
                                  print(ingredients);
                                  ingredients[index] = value;
                                },
                              ),
                              flex: 5,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              kFixedSizedBox,
              InkWell(
                onTap: () {
                  if (ingredients.length == 0 || ingredients.last != '') {
                    setState(() {
                      ingredients.add('');
                    });
                  }
                },
                splashColor: kPrimaryColor,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      // color: kPrimaryColor,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Ingredient",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            letterSpacing: 1.1),
                      )
                    ],
                  ),
                ),
              ),
              kFixedSizedBox,
              Text(
                'Cooking Steps',
                style: kFormHeadingStyle,
              ),
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          steps.removeAt(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CircleAvatar(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: kLightGreenColor,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: kTextFieldInputDecoration(
                                    errorText: errorText),
                                controller:
                                    TextEditingController(text: steps[index]),
                                style: kTextFieldStyle,
                                maxLines: 3,
                                onChanged: (value) {
                                  steps[index] = value;
                                },
                              ),
                              flex: 5,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              kFixedSizedBox,
              InkWell(
                splashColor: kPrimaryColor,
                onTap: () {
                  if (steps.length == 0 || steps.last != '') {
                    setState(() {
                      steps.add('');
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 30,
                        color: kSecondaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Steps",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            letterSpacing: 1.1),
                      )
                    ],
                  ),
                ),
              ),
              kFixedSizedBox,
              Text(
                'All done?\nClick submit button 😊',
                style: kFormHeadingStyle,
              ),
              kFixedSizedBox,
              InkWell(
                splashColor: kPrimaryColor,
                onTap: () async {
                  setState(() {
                    steps = steps.where((step) => step != '').toList();
                    ingredients = ingredients
                        .where((ingredient) => ingredient != '')
                        .toList();
                  });

                  if (_foodNameController.text.isNotEmpty && steps.length > 0) {
                    final downloadURL = await uploadAndGetImageURL(
                        image!, _foodNameController.text.toString());
                    setState(() {
                      imageUrl = downloadURL;
                    });
                    await _firestore.collection('recipes').add({
                      'name': _foodNameController.text,
                      'description': _descriptionController.text,
                      'duration': cookTime.toString().substring(0, 2),
                      'ingredients': ingredients,
                      'steps': steps,
                      'photo': imageUrl,
                      'veg': isVeg,
                      'category': category,
                      'chef': Provider.of<AuthProvider>(context, listen: false)
                          .auth
                          .currentUser!
                          .displayName,
                    }).then((value) => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Upload Success',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: kLightGreenColor)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Image(
                                  image: AssetImage('images/party.png'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    'Your Recipe has been uploaded,\nyou can see it on your profile',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Dosis-Bold',
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: kLightGreenColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Text(
                                        'Back to Home',
                                        style: kFormHeadingStyle.copyWith(
                                            color: Colors.yellow),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NavBarController(),
                                        ),
                                        (route) => false);
                                    // Navigation.changeScreen(context, Home());
                                  },
                                ),
                              ],
                            ),
                          );
                        }));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('error')));
                  }

                  setState(() {
                    ingredients = ['', ''];
                    steps = ['', '', ''];
                    errorText = '';
                    cookTime = 30;
                  });
                },
                child: FlatButtonWithText(
                    text: 'Submit', buttonColor: kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future alertDialog(BuildContext context) {
    TextStyle buttonTextStyle = TextStyle(fontSize: 18, letterSpacing: 1.1);
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                'Image Source...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    imagePicker(ImageSource.gallery, context);
                  },
                  child: Text(
                    'Gallery',
                    style: buttonTextStyle,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    imagePicker(ImageSource.camera, context);
                  },
                  child: Text(
                    'Camera',
                    style: buttonTextStyle,
                  ),
                )
              ],
            ));
  }

  SliderThemeData sliderThemeData(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: kSecondaryColor,
      inactiveTrackColor: Colors.red[100],
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
      thumbColor: kPrimaryColor,
      overlayColor: kPrimaryColor.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      activeTickMarkColor: kPrimaryColor,
      inactiveTickMarkColor: kDarkGreenColor,
      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: kSecondaryColor,
      valueIndicatorTextStyle: TextStyle(
          fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  var kSliderText = TextStyle(
      color: Colors.grey,
      fontSize: 18,
      letterSpacing: 1.2,
      fontWeight: FontWeight.bold);
}
