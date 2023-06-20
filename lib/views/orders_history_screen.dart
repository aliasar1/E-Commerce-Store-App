import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';

class OrdersHistoryScreen extends StatelessWidget {
  OrdersHistoryScreen({super.key});

  static const String routeName = '/orderHistoryScreen';

  final AuthenticateController authController =
      Get.put(AuthenticateController());
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode
            ? DarkColorsManager.scaffoldBgColor
            : ColorsManager.scaffoldBgColor,
        drawer: BuyerHomeDrawer(controller: authController),
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? DarkColorsManager.scaffoldBgColor
              : ColorsManager.scaffoldBgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorsManager.secondaryColor),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
          child: Center(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Txt(
                    textAlign: TextAlign.start,
                    text: StringsManager.myOrdersTxt,
                    fontWeight: FontWeightManager.bold,
                    color: isDarkMode
                        ? DarkColorsManager.whiteColor
                        : ColorsManager.primaryColor,
                    fontSize: FontSize.headerFontSize,
                    fontFamily: FontsManager.fontFamilyPoppins,
                  ),
                ),
                const SizedBox(height: SizeManager.sizeM),
                Obx(
                  () {
                    if (orderController.isLoading.value) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.secondaryColor,
                          ),
                        ),
                      );
                    } else if (orderController.orders.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.all(PaddingManager.paddingXS),
                          itemCount: orderController.orders.length,
                          itemBuilder: (ctx, i) {
                            return OrderCard(
                              orderController.orders[i],
                            );
                          },
                        ),
                      );
                    } else {
                      return const Column(
                        children: [
                          SizedBox(height: SizeManager.sizeXL * 3),
                          NoOrdersTemplate(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
