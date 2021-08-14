import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/drawer_tile.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/notification.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/search.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/about_page.dart';
import 'package:nepali_food_recipes/screens/setting_screen.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext cxt;
  MyDrawer(this.cxt);
  @override
  Widget build(cntx) {
    double width = ScreenSize.getWidth(cxt);
    double height = ScreenSize.getHeight(cxt) - 80;

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
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                )),
                          ),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset('images/profile_loading.gif'),
                          imageUrl:
                              Provider.of<AuthProvider>(cxt, listen: false)
                                  .auth
                                  .currentUser!
                                  .photoURL!,
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 150),
                      child: Column(
                        children: [
                          Provider.of<AuthProvider>(cntx, listen: false).isAdmin
                              ? DrawerTile('Admin', Icons.local_police)
                              : Container(),
                          InkWell(
                              onTap: () {
                                Navigator.pop(cntx);
                              },
                              child: DrawerTile('Home', Icons.home_filled)),
                          InkWell(
                              onTap: () {
                                Navigator.pop(cntx);
                                showSearch(
                                    context: cntx,
                                    delegate: CustomSearchDelegate());
                              },
                              child: DrawerTile('Explore', Icons.search)),
                          InkWell(
                              onTap: () async {
                                // await NotificationService()
                                //     .showNotification('test');
                                Navigation.changeScreen(cntx, SettingScreen());
                              },
                              child: DrawerTile('Settings', Icons.settings)),
                          InkWell(
                              onTap: () {
                                Navigation.changeScreen(cntx, AboutUsPage());
                              },
                              child: DrawerTile('About', Icons.info)),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                Navigator.pop(cxt);
                                Provider.of<AuthProvider>(cxt, listen: false)
                                    .signOut(cxt);
                                // Navigation.changeScreenWithReplacement(
                                //     context, SignUpScreen());
                              },
                              child: DrawerTile('Log out', Icons.logout))
                        ],
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
