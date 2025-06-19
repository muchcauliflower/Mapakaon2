import 'package:flutter/material.dart';

import '../../data/tilesData.dart';
import '../../utils/appColors.dart';
import '../../utils/screenDimensions.dart';
import '../../utils/searchbar_Widget.dart';
import '../../utils/tilesWdiget.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Portion of the app. Will include the text Mayong Hapon! Header, Subheader
            // Also include the sections for food types

            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.screenHeight * 0.1,
                    left: SizeConfig.screenWidth * 0.06,
                    right: SizeConfig.screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchbarWidget(controller: _searchController),
                    Text(
                      "Mayong Hapon!",
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: SizeConfig.screenWidth * 0.08,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenWidth * 0.004),
                    Text(
                      "Insert Slogan here...? (Idk you pick)",
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        fontSize: SizeConfig.screenWidth * 0.04,
                        color: appColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: SizeConfig.screenHeight * 0.248,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Upper row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return foodtileWidget(
                        labelfoodTile: foodTiles[index].labelfoodTile,
                        foodTilesvgPath: foodTiles[index].foodTilesvgPath,
                      );
                    }),
                  ),

                  // Padding inbetween
                  SizedBox(height: SizeConfig.screenHeight * 0.02),

                  // Lower Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return foodtileWidget(
                        labelfoodTile: foodTiles[index + 4].labelfoodTile,
                        foodTilesvgPath: foodTiles[index + 4].foodTilesvgPath,
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Mid Portion. Will hold container with only 3 tiles: Near me, Trending,
            // Iloilo Famous. Similar to  Top portion with rows and columns
            Container(
              height: SizeConfig.screenHeight * 0.275,
              child: Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.025, left: SizeConfig.screenWidth * 0.02, right: SizeConfig.screenWidth * 0.02),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) {
                        return filtertileWidget(
                          tileColor: filterTiles[index].tileColor,
                          filterLabel: filterTiles[index].filterLabel,
                          filterSublabel: filterTiles[index].filterSublabel,
                          filterTilesvgPath: filterTiles[index].filterTilesvgPath,
                        );
                      }),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) {
                        return filtertileWidget(
                          tileColor: filterTiles[index+2].tileColor,
                          filterLabel: filterTiles[index+2].filterLabel,
                          filterSublabel: filterTiles[index+2].filterSublabel,
                          filterTilesvgPath: filterTiles[index+2].filterTilesvgPath,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.015, left: SizeConfig.screenWidth * 0.06, right: SizeConfig.screenWidth * 0.015),
                  child: Text(
                    "Special Offers",
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: SizeConfig.screenWidth * 0.075,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.0075, left: SizeConfig.screenWidth * 0.06, right: SizeConfig.screenWidth * 0.015),
                  child: Text(
                    "Insert Slogan here..? (Idk you pick?)",
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: SizeConfig.screenWidth * 0.04,
                      color: appColor,
                    ),
                  ),
                ),

                Container(
                  height: SizeConfig.screenHeight * 0.2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.01, left: SizeConfig.screenWidth * 0.06),
                          child: Container(
                            width: SizeConfig.screenHeight * 0.3,
                            height: SizeConfig.screenHeight * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}