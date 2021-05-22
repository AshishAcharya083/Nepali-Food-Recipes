import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            size: 0,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/lenna.png'),
                        fit: BoxFit.cover),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/lenna.png'),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            TextField(
                style: TextStyle(color: myDarkColor),
                cursorColor: myPrimaryColor,
                decoration: kTextFieldInputDecoration)
          ],
        ),
      ),
    );
  }
}
