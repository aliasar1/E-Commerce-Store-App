import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';

class AddProductTemplate extends StatelessWidget {
  const AddProductTemplate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/add_product.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Txt(
              text: "You haven't added any product.",
              fontFamily: FontsManager.fontFamilyPoppins,
              fontSize: FontSize.textFontSize,
              color: isDarkMode
                  ? DarkColorsManager.whiteColor
                  : ColorsManager.primaryColor,
              fontWeight: FontWeightManager.medium,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
