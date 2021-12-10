import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

class IconWithNameCard extends StatelessWidget {
  final String assetImagePath;
  final String foodCategory;
  final VoidCallback? onTap;
  IconWithNameCard(
      {this.assetImagePath = 'images/burger.png',
      this.foodCategory = '',
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: kPrimaryColor,
      onTap: onTap,
      child: Container(
        width: 120,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor.withOpacity(0.5), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(assetImagePath),
              height: 30,
            ),
            Text(
              '  $foodCategory',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
