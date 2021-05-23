import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
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
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 18),
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                      style: TextStyle(color: myDarkColor),
                      cursorColor: myPrimaryColor,
                      decoration: kTextFieldInputDecoration),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      color: myPrimaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: IconButton(
                      color: myPrimaryColor,
                      onPressed: () {},
                      icon: Icon(Icons.settings)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Top Recipes',
              style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 24,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: ScreenSize.getHeight(context) * 0.45,
              child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 180,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              height: 220,
                              width: 180,
                              bottom: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Colors.lightBlueAccent.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: ScreenSize.getHeight(context) *
                                            0.09,
                                      ),
                                      Text(
                                        'Mexican Egg Mix',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Dosis',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 3),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey
                                                    .withOpacity(0.45)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: Colors.deepOrange,
                                                ),
                                                Text(' 4.5')
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 5),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey
                                                    .withOpacity(0.45)),
                                            child: Text("easy"),
                                          )
                                        ],
                                      ),
                                      Text('⏱' + ' 15 min',
                                          style: TextStyle(
                                              fontFamily: 'Dosis',
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w600)),
                                      Expanded(
                                        child: Text(
                                          'A gentle combination of Carefully choosen veggies with a Mexican taste ',
                                          style: TextStyle(
                                              fontFamily: 'Dosis',
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              height: ScreenSize.getHeight(context) * 0.19,
                              width: ScreenSize.getWidth(context) * 0.3,
                              top: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/lenna.png')),
                                    color: Colors.red,
                                    shape: BoxShape.circle),
                              ),
                            ),
                            Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        ' Save',
                                        style: TextStyle(
                                            fontFamily: 'Dosis',
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
