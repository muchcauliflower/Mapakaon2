import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapakaon2/utils/screenDimensions.dart';

import 'appColors.dart';

// Tile Class
class foodTileData {
  final String labelfoodTile;
  final String foodTilesvgPath;

  // To be added in the future
  // // New field for data as to create the widget page. Will affect other data classes as well in the future
  // final Widget appPage;
  //
  // foodTileData({required this.labelfoodTile, required this.foodTilesvgPath, required this.appPage});
  foodTileData({required this.labelfoodTile, required this.foodTilesvgPath});
}

class filterTileData {
  final Color tileColor;
  final String filterLabel;
  final String filterSublabel;
  final String filterTilesvgPath;

  filterTileData({required this.tileColor,required this.filterLabel, required this.filterSublabel, required this.filterTilesvgPath,
  });
}

class btmnavgiationTilesData{
  final String btmnavigationTileLabel;
  final String btmnavigationAssetpath;

  // Creating the function to click on the bottom navigation first.
  final Widget appPage;

  btmnavgiationTilesData({required this.btmnavigationTileLabel, required this.btmnavigationAssetpath, required this.appPage});
}


// Building the food tiles
class foodtileWidget extends StatelessWidget {
  final String labelfoodTile;
  final String foodTilesvgPath;

  const foodtileWidget({
    required this.labelfoodTile,
    required this.foodTilesvgPath,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        print('Tapped $labelfoodTile');
      },
      child: Container(
        height: SizeConfig.screenHeight * 0.105,
        width: SizeConfig.screenWidth * 0.2,
        decoration: BoxDecoration(
          color: secondaryBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(foodTilesvgPath, height: SizeConfig.screenHeight * 0.05, width: SizeConfig.screenHeight * 0.05),
            SizedBox(height: SizeConfig.screenHeight * 0.004),
            Text(
              labelfoodTile,
              style: TextStyle(
                fontFamily: 'FredokaOne',
                fontSize: SizeConfig.screenWidth * 0.0275,
                color: Color(0xFF5B5B5B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class filtertileWidget extends StatelessWidget {
  final Color tileColor;
  final String filterLabel;
  final String filterSublabel;
  final String filterTilesvgPath;

  const filtertileWidget({
    required this.tileColor,
    required this.filterLabel,
    required this.filterSublabel,
    required this.filterTilesvgPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        print('Tapped $filterLabel');
      },
      child: Container(
        height: SizeConfig.screenHeight * 0.115,
        width: SizeConfig.screenWidth * 0.45,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Texts with padding
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.025, right: SizeConfig.screenWidth * 0.2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filterLabel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: SizeConfig.screenWidth * 0.04,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.0065),
                    Text(
                      filterSublabel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: SizeConfig.screenWidth * 0.025,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SVG positioned bottom right
            Positioned(
              bottom: -20,
              right: -20,
              child: SvgPicture.asset(filterTilesvgPath, height: SizeConfig.screenHeight * 0.125, width: SizeConfig.screenWidth * 0.125),
            ),
          ],
        ),
      ),
    );
  }
}

// UNUSED AT THE MOMENT, MIGHT/WILL REMOVE IN THE FUTURE
class btmnavigationWidget extends StatelessWidget {
  final String btmnavigationTileLabel;
  final String btmnavigationAssetpath;

  const btmnavigationWidget({
    required this.btmnavigationTileLabel,
    required this.btmnavigationAssetpath,
    Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          btmnavigationAssetpath,
          height: SizeConfig.screenWidth * 4,
          width: 60,
        ),

        Text(
          btmnavigationTileLabel,
          style: TextStyle(
            fontFamily: 'fredokaOne',
            color: appColor,
          ),
        ),
      ],
    );
  }
}

