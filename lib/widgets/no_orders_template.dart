import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';

class NoOrdersTemplate extends StatelessWidget {
  const NoOrdersTemplate({
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
            'assets/images/no_order.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Txt(
              text: "No order is placed yet.",
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
