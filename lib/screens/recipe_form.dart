import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/alert_dialog.dart';
import 'package:nepali_food_recipes/components/flat_button.dart';
import 'package:nepali_food_recipes/components/snack_bar.dart';
import 'package:nepali_food_recipes/components/toggle_box.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/delete_recipe.dart';
import 'package:nepali_food_recipes/helpers/firebase_storage.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeForm extends StatefulWidget {
  final bool isEditing;
  final QueryDocumentSnapshot? editingSnapshot;
  RecipeForm({this.isEditing = false, this.editingSnapshot});
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  SharedPreferences? prefs;
  List<dynamic> ingredients = ['', ''];
  List<dynamic> steps = ['', '', ''];
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
  AuthProvider? provider;
  int? recipeCount;
  bool isLoading = false;
  bool imageExist = false;
  bool isEasy = true;
  var data;
  @override
  void initState() {
    super.initState();
    loadSharedPref();
    if (widget.isEditing) {
      data = widget.editingSnapshot!.data();
      _descriptionController = TextEditingController(text: data['description']);
      _foodNameController = TextEditingController(text: data['name']);
      isVeg = data['veg'];
      category = data['category'];
      isEasy = data['isEasy'];
      cookTime = double.parse(data['duration']).toDouble();
      ingredients = data['ingredients'];
      steps = data['steps'];
    }
    provider = Provider.of<AuthProvider>(context, listen: false);
  }

  void loadSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void imagePicker(ImageSource source, BuildContext context) async {
    var temp = await _picker.pickImage(
        source: source, imageQuality: 80, maxWidth: 1280, maxHeight: 720);
    setState(() {
      image = temp;
      imageFile = File(temp!.path);
      imageExist = true;
    });
    Navigator.pop(context);
  }

  void resetFocusOfCursor() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future showPleaseWaitDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            title: Center(
              child: Text(
                'Please Wait',
                style: kFormHeadingStyle,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isLoading) {
          showPleaseWaitDialog(context);
        }

        return Future.value(true);
      },
      child: GestureDetector(
        onTap: resetFocusOfCursor,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (isLoading)
                      showPleaseWaitDialog(context);
                    else
                      Navigation.changeScreenWithReplacement(
                          context, NavBarController());
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
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
                      child: widget.isEditing && imageFile == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                data['photo'],
                                fit: BoxFit.cover,
                              ),
                            )
                          : imageFile == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                        image:
                                            AssetImage('images/gallery.png')),
                                    Text(
                                      'Add Cover Photo',
                                      style: kFormHeadingStyle.copyWith(
                                          fontSize: 18),
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
                          resetFocusOfCursor();
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
                        resetFocusOfCursor();
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
                  Text(
                    'Difficulty',
                    style: kFormHeadingStyle,
                  ),

                  Center(
                    heightFactor: 1.3,
                    child: ToggleButtons(
                        borderRadius: BorderRadius.circular(20),
                        // splashColor: kPrimaryColor,
                        children: [
                          ToggleBoxButton(
                            title: 'Easy',
                            imgPath: 'images/snap.png',
                            width: ScreenSize.getWidth(context) * 0.35,
                          ),
                          ToggleBoxButton(
                            width: ScreenSize.getWidth(context) * 0.35,
                            title: 'Hard',
                            imgPath: 'images/effort.png',
                          ),
                        ],
                        isSelected: [isEasy, !isEasy],
                        onPressed: (a) {
                          resetFocusOfCursor();
                          if (a == 0)
                            setState(() {
                              isEasy = true;
                            });
                          else
                            setState(() {
                              isEasy = false;
                            });
                        },

                        // renderBorder: false,
                        fillColor:
                            isEasy ? kLightGreenColor : Colors.redAccent),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cooking Duration',
                          style:
                              kFormHeadingStyle.copyWith(fontFamily: 'Dosis'),
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
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10),
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
                          key: widget.isEditing
                              ? new ObjectKey(ingredients[index])
                              : UniqueKey(),
                          onDismissed: (direction) {
                            if (ingredients.contains(ingredients[index])) {
                              setState(() {
                                ingredients.removeAt(index);
                              });
                            }
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
                          key: widget.isEditing
                              ? new ObjectKey(steps[index])
                              : UniqueKey(),
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
                                    controller: TextEditingController(
                                        text: steps[index]),
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

                  /// submit button
                  InkWell(
                    splashColor: kPrimaryColor,
                    onTap: () async {
                      setState(() {
                        steps = steps.where((step) => step != '').toList();
                        ingredients = ingredients
                            .where((ingredient) => ingredient != '')
                            .toList();
                      });

                      if (_foodNameController.text.isNotEmpty &&
                          steps.length > 0 &&
                          (imageExist || widget.isEditing)) {
                        setState(() {
                          isLoading = true;
                        });
                        isLoading
                            ? showDialog(
                                context: this.context,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(this.context)
                                      .alertDialogWithImage(
                                          showButton: false,
                                          titleString: 'Uploading! Please wait',
                                          imagePath: 'images/waiting.png',
                                          descriptionText:
                                              'Recipe upload in progress');
                                })
                            : Container();
                        var userDocument = _firestore
                            .collection('users')
                            .doc(provider!.auth.currentUser!.uid);

                        /// uploading image to firebase storage and getting download URL

                        if (widget.isEditing) {
                          if (image == null) {
                            setState(() {
                              imageUrl = data['photo'];
                            });
                          } else {
                            DeleteRecipe()
                                .deleteImageFromFirebase(data['photo']);
                            final downloadURL = await uploadAndGetImageURL(
                                image!, _foodNameController.text.toString());
                            setState(() {
                              imageUrl = downloadURL;
                            });
                          }

                          await _firestore
                              .collection('recipes')
                              .doc(widget.editingSnapshot!.id)
                              .update({
                            'name': _foodNameController.text,
                            'description': _descriptionController.text,
                            'duration': cookTime.toString().substring(0, 2),
                            'ingredients': ingredients,
                            'steps': steps,
                            'photo': imageUrl,
                            'veg': isVeg,
                            'category': category,
                            'chefImage': provider!.auth.currentUser!.photoURL,
                            'chef': provider!.auth.currentUser!.displayName,
                            'chefId': provider!.auth.currentUser!.uid,
                            'views': data['views'],
                            'isEasy': isEasy,
                            'status': prefs!.getBool('isAdmin') ?? false
                                ? 'approved'
                                : 'pending',
                            'date': DateTime.now().toLocal(),
                          }).then((value) {
                            showSnackBar(
                                'Edited SuccessFully 😊', context, Icons.edit);
                            Navigator.pop(context);
                          });
                        } else {
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
                            'chefImage': provider!.auth.currentUser!.photoURL,
                            'chef': provider!.auth.currentUser!.displayName,
                            'chefId': provider!.auth.currentUser!.uid,
                            'views': 1,
                            'isEasy': isEasy,
                            'status': prefs!.getBool('isAdmin') ?? false
                                ? 'approved'
                                : 'pending',
                            'date': DateTime.now().toLocal()
                          }).then(
                            (value) => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                /// getting no. of recipe by user and incrementing it if he submit the new recipe
                                userDocument.get().then(
                                  (value) {
                                    setState(
                                      () {
                                        recipeCount = value.data()!['recipes'];
                                      },
                                    );
                                    userDocument.set(
                                      {
                                        'recipes': recipeCount! + 1,
                                      },
                                      SetOptions(merge: true),
                                    );

                                    setState(
                                      () {
                                        isLoading = false;
                                      },
                                    );
                                  },
                                );

                                /// returning alert dialog if recipe upload is successful
                                return CustomAlertDialog(context)
                                    .alertDialogWithImage();
                              },
                            ),
                          );
                        }

                        /// adding recipe to fireStore

                        setState(() {
                          ingredients = ['', ''];
                          steps = ['', '', ''];
                          errorText = '';
                          cookTime = 30;
                        });
                      } else {
                        showSnackBar('All Fields are mandatory', context,
                            Icons.error_outline);
                      }
                    },
                    child: FlatButtonWithText(
                        text: isLoading ? 'Uploading...' : 'Submit',
                        buttonColor: kPrimaryColor),
                  ),
                ],
              ),
            ),
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
