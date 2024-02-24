import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smoments/res/colors.dart';

import '../res/assets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ThemeColors.whiteColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: AppBar(
              backgroundColor: ThemeColors.whiteColor,
              flexibleSpace: Column(
                children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: SvgPicture.asset(assetLogoBlue),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Expanded(flex: 1, child: Text('For You', style: TextStyle(fontWeight: FontWeight.w500),)),
                  const Divider(
                    thickness: 1,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
