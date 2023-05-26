import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';

class EmptyCartTemplate extends StatelessWidget {
  const EmptyCartTemplate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/add_to_cart.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Txt(
              text: "No products are added to cart yet.",
              fontFamily: FontsManager.fontFamilyPoppins,
              fontSize: FontSize.textFontSize,
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
