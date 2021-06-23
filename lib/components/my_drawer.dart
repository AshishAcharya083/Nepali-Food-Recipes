import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.getWidth(context);
    double height = ScreenSize.getHeight(context);
    print(width);
    print(height);
    return Container(
      width: width * 0.7,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        height: height * 0.7,
                        decoration: BoxDecoration(
                            color: kPrimaryColor.withAlpha(50),
                            shape: BoxShape.circle),
                      ),
                      left: -width * 0.45,
                      right: -5,
                      top: -width * 0.45,
                    ),
                    Positioned(
                      child: Container(
                        height: height * 0.55,
                        decoration: BoxDecoration(
                            color: kPrimaryColor.withAlpha(50),
                            shape: BoxShape.circle),
                      ),
                      left: -width * 0.45, // -200
                      right: 0,
                      top: -width * 0.33,
                    ),
                    Positioned(
                      child: Container(
                        height: height * 0.4,
                        decoration: BoxDecoration(
                            color: kPrimaryColor.withAlpha(50),
                            shape: BoxShape.circle),
                      ),
                      left: -width * 0.45,
                      right: 30,
                      top: -width * 0.2,
                    ),
                    Positioned(
                      left: 15,
                      right: 200,
                      top: 30,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('images/lenna.png'))),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
