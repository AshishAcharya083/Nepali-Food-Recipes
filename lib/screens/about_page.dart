import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);
  static const kBoldTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
  static const kNormalTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w600);
  static const kSizedBox = SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'About Us',
          style: kFormHeadingStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: const <TextSpan>[
                  TextSpan(text: 'Nepali Food Recipes', style: kBoldTextStyle),
                  TextSpan(
                      text:
                          ' is a recipe app based on style of Nepali food community where we can learn and share different kind of food recipes. ',
                      style: kNormalTextStyle),
                ],
              ),
            ),
            kSizedBox,
            kSizedBox,
            Text(
              'Our Mission',
              style: kFormHeadingStyle,
            ),
            kSizedBox,
            Text(
              'Be the believed and innovative app which will introduce lots of traditional foods from all around the Country',
              style: kNormalTextStyle,
            ),
            kSizedBox,
            kSizedBox,
            Text(
              'We Build Strong Relationships',
              style: kFormHeadingStyle,
            ),
            kSizedBox,
            Text(
              'We put vigorously in building long haul connection between food enthusiasts',
              style: kNormalTextStyle,
            ),
            kSizedBox,
            kSizedBox,
            Text(
              'We are Quality Conscious',
              style: kFormHeadingStyle,
            ),
            kSizedBox,
            Text(
              'We adore quality searches and User Experience. Henceforth, our prime center is quality that wins us some genuine praises',
              style: kNormalTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
