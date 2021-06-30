import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:timelines/timelines.dart';

class CookingScreen extends StatefulWidget {
  const CookingScreen({Key? key}) : super(key: key);

  @override
  _CookingScreenState createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  String sampleText =
      'This is one of the most popular food in Mexico. It is not only the case of mexico, it is also famous all around the world which is really nice thing. The main Thing that makes special about this food is that it costs very less';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(top: 10),
                title: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /// food title
                      Text(
                        'Mexican Egg Mix',
                        style: kFormHeadingStyle.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                collapseMode: CollapseMode.parallax,
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    image: DecorationImage(
                        image: AssetImage('images/lenna.png'),
                        fit: BoxFit.cover),
                  ),
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kFixedSizedBox,
                  Text(
                    'Food. 60 mins',
                    style: kSecondaryTextStyle,
                  ),
                  kFixedSizedBox,
                  kDivider,
                  Text(
                    'Description',
                    style: kFormHeadingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    sampleText,
                    style: kSecondaryTextStyle,
                  ),
                  kDivider,
                  Text(
                    'Ingredients',
                    style: kFormHeadingStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ])),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.1)),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '1/2 butter',
                          style: TextStyle(
                              fontFamily: 'Dosis-SemiBold', letterSpacing: 1.1),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Steps',
                style: kFormHeadingStyle,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            sliver: SliverToBoxAdapter(
                child: FixedTimeline.tileBuilder(
              theme: TimelineThemeData(
                nodePosition: 0,
                color: Colors.red,
                indicatorTheme: IndicatorThemeData(
                  position: 0.5,
                  size: 15.0,
                ),
                connectorTheme: ConnectorThemeData(
                  thickness: 2.5,
                ),
              ),
              mainAxisSize: MainAxisSize.max,
              builder: TimelineTileBuilder.connectedFromStyle(
                oppositeContentsBuilder: (context, index) => Container(
                  width: 5,
                ),
                contentsAlign: ContentsAlign.basic,
                contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '08:54 PM',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                connectorStyleBuilder: (context, index) =>
                    ConnectorStyle.solidLine,
                indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                itemCount: 50,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
