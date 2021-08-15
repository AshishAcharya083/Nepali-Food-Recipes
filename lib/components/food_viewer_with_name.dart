import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/profile.dart';

class FoodViewerWithName extends StatelessWidget {
  final String? chefId;
  final String? chefImageURL;
  final String? chefName;
  final String? foodName;
  final String? duration;
  final String? foodImageURL;

  FoodViewerWithName(
      {this.chefId,
      this.chefImageURL,
      this.chefName,
      this.foodName,
      this.duration,
      this.foodImageURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// chef name and photo
          Expanded(
            child: InkWell(
              onTap: () {
                Navigation.changeScreen(
                  context,
                  Profile(
                    chefId,
                  ),
                );
                //TODO goto profile
              },
              child: Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: chefImageURL!,
                        placeholder: (context, url) =>
                            Image.asset('images/profile_loading.gif'),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.network_check),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      chefName!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimaryTextColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),

          ///food image
          Expanded(
            flex: 4,
            child: Container(
              height: 150,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  placeholder: (BuildContext context, photo) {
                    return Image(
                      image: AssetImage('images/loader.gif'),
                    );
                  },
                  imageUrl: foodImageURL!,
                  errorWidget: (context, url, error) => Center(
                      child: Icon(
                    Icons.network_check,
                    size: 35,
                    color: Colors.red,
                  )),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Expanded(
            child: Text(
              foodName!,
              overflow: TextOverflow.ellipsis,
              style: kFormHeadingStyle.copyWith(fontSize: 18),
            ),
          ),
          // SizedBox(
          //   height: 5,
          // ),

          Expanded(
            child: Text(
              'Food. ${duration!} mins',
              style: kSecondaryTextStyle.copyWith(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
