import 'package:e_commerce_shopping_app/controllers/product_controller.dart';
import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:e_commerce_shopping_app/views/seller_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../models/product_model.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen(
      {super.key, required this.product, required this.controller});

  final Product product;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.scaffoldBgColor,
        body: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: product.id,
                  child: Image.network(product.imageUrl),
                ),
                Positioned(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: ColorsManager.secondaryColor,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: SizeManager.sizeXL,
            ),
            Txt(
              text: product.name.capitalizeFirstOfEach,
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.headerFontSize,
              fontFamily: FontsManager.fontFamilyPoppins,
            ),
            Txt(
              textAlign: TextAlign.center,
              text: product.description.capitalize,
              fontWeight: FontWeightManager.medium,
              fontSize: FontSize.textFontSize,
              fontFamily: FontsManager.fontFamilyPoppins,
            ),
            const SizedBox(
              height: SizeManager.sizeL,
            ),
            const CircularStepProgressIndicatorWidget(
              totalSteps: 5,
              currentStep: 3,
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: ColorsManager.secondaryColor,
          activeBackgroundColor: ColorsManager.secondaryColor,
          overlayOpacity: 0,
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.delete,
                color: ColorsManager.lightSecondaryColor,
              ),
              onTap: () => {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: ColorsManager.scaffoldBgColor,
                    title: const Text('Confirm Delete Product'),
                    content: const Text(
                      'Are you sure you want to delete the product?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: ColorsManager.secondaryColor),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorsManager.secondaryColor)),
                        onPressed: () async {
                          controller.deleteProduct(product.id);
                          Get.offAll(SellerHomeScreen());
                        },
                        child: const Text(
                          'Delete',
                          style:
                              TextStyle(color: ColorsManager.backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.edit,
                color: ColorsManager.lightSecondaryColor,
              ),
              onTap: () => {},
            ),
          ],
        ),
      ),
    );
  }
}

class CircularStepProgressIndicatorWidget extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CircularStepProgressIndicatorWidget({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        height: 120,
        child: CircularProgressIndicator(
          value: currentStep / totalSteps,
          strokeWidth: 10,
          backgroundColor: ColorsManager.lightSecondaryColor.withOpacity(0.3),
          valueColor:
              const AlwaysStoppedAnimation<Color>(ColorsManager.secondaryColor),
        ),
      ),
    );
  }
}
