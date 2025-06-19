import 'package:flutter/material.dart';
import 'package:mapakaon2/utils/screenDimensions.dart';
import 'appColors.dart';

class searchbarWidget extends StatelessWidget {
  final TextEditingController controller;

  const searchbarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.005),
      child: Container(
        height: SizeConfig.screenHeight * 0.05,
        decoration: BoxDecoration(
          color: secondaryBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.01),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Color(0xFF5B5B5B)),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Color(0xFF5B5B5B), fontSize: SizeConfig.screenWidth * 0.05),
              prefixIcon: Icon(Icons.search, color: Color(0xFF5B5B5B)),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
