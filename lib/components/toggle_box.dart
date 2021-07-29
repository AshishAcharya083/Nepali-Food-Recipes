import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';

class ToggleBoxButton extends StatelessWidget {
  final String? assetImagePath;
  final String? title;

  ToggleBoxButton(
      {this.title = 'Veg', this.assetImagePath = 'images/broccoli.png'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.getWidth(context) * 0.35,
      color: Colors.grey.withOpacity(0.28),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: Column(
          children: [
            Image(
              image: AssetImage(assetImagePath!),
              height: ScreenSize.getHeight(context) * 0.05,
            ),
            Text(
              title!,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
