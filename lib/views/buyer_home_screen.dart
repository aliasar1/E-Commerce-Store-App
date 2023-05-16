import 'package:e_commerce_shopping_app/views/seller_home_screen.dart';
import 'package:e_commerce_shopping_app/widgets/buyer_home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/search_controller.dart' as ctrl;
import '../managers/colors_manager.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_search.dart';
import '../widgets/custom_text.dart';

class BuyerHomeScreen extends StatelessWidget {
  BuyerHomeScreen({super.key});

  final ProductController productController = Get.put(ProductController());
  final ctrl.SearchController searchController =
      Get.put(ctrl.SearchController());
  final AuthenticateController authController =
      Get.put(AuthenticateController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.scaffoldBgColor,
        drawer: BuyerHomeDrawer(controller: authController),
        appBar: AppBar(
          backgroundColor: ColorsManager.scaffoldBgColor,
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
                  child: const Txt(
                    textAlign: TextAlign.start,
                    text: StringsManager.allProductsTxt,
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.headerFontSize,
                    fontFamily: FontsManager.fontFamilyPoppins,
                  ),
                ),
                const SizedBox(height: 12),
                CustomSearchWidget(
                  onFieldSubmit: (value) {
                    searchController.searchProduct(value.trim());
                  },
                ),
                const SizedBox(height: 12),
                Obx(
                  () {
                    if (searchController.searchedProducts.isNotEmpty) {
                      return Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: searchController.searchedProducts.length,
                          itemBuilder: (ctx, i) {
                            final prod = searchController.searchedProducts[i];
                            return ProductsCard(
                              prod: prod,
                              controller: productController,
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                        ),
                      );
                    } else if (productController.products.isEmpty) {
                      return const Column(
                        children: [
                          SizedBox(height: SizeManager.sizeXL * 3),
                          NoProductTemplate(),
                        ],
                      );
                    } else {
                      return Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: productController.products.length,
                          itemBuilder: (ctx, i) {
                            final prod = productController.products[i];
                            return ProductsCard(
                              prod: prod,
                              controller: productController,
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                        ),
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

class NoProductTemplate extends StatelessWidget {
  const NoProductTemplate({
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
            'assets/images/no_products.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Txt(
              text: "No products are added yet.",
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
