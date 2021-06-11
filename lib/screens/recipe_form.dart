import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/text_field.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({Key? key}) : super(key: key);

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 180,
                width: ScreenSize.getWidth(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('images/gallery.png')),
                    Text(
                      'Add Cover Photo',
                      style: kFormHeadingStyle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(20)),
              ),
              Text(
                'Food name',
                style: kFormHeadingStyle,
              ),
              StandardTextField(
                hintText: 'Enter Food Name',
              ),
              Text(
                'Description',
                style: kFormHeadingStyle,
              ),
              StandardTextField(
                maxLine: 3,
                hintText: 'Tell a little about your food',
              )
            ],
          ),
        ),
      ),
    );
  }
}
