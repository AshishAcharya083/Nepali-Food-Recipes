import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/login_checker.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int page = 0;
  List<ItemData> data = [
    ItemData(Colors.red.shade400, "images/logo.png", "500+",
        " Indian & Nepali Recipes", "In One Place"),
    ItemData(Colors.deepPurpleAccent, "images/upload.png", "Upload Your own ",
        "Recipe", "& share with Friends"),
    ItemData(
        Colors.green, "images/chef.png", "Be", "Your Own Chef", "Give Star!"),
    ItemData(Colors.yellow, "images/meat.png", "Swipe to Continue", "Used for",
        "Onboarding design"),
  ];

  LiquidController liquidController = LiquidController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe.builder(
              positionSlideIcon: 0.8,
              slideIconWidget: Icon(
                Icons.arrow_back_ios,
                color: kPrimaryColor,
                size: 30,
              ),
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  width: ScreenSize.getWidth(context),
                  color: data[index].color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        data[index].image,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            data[index].text1,
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(data[index].text2,
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w600)),
                          Text(data[index].text3,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: data.length)
        ],
      ),
    );
  }

  pageChangeCallback(int incomingPage) async {
    print('data length ${data.length}');
    print(liquidController.currentPage);
    if (liquidController.currentPage == (data.length - 1)) {
      Navigation.changeScreenWithReplacement(context, LogInChecker());
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('showOnBoardingScreen', false);
    }
  }
}

class ItemData {
  final Color color;
  final String image;
  final String text1;
  final String text2;
  final String text3;

  ItemData(this.color, this.image, this.text1, this.text2, this.text3);
}
