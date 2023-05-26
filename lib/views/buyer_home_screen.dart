import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart' as ctrl;
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  static const String routeName = '/buyerHomeScreen';

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final ProductController productController = Get.put(ProductController());

  final ctrl.SearchController searchController =
      Get.put(ctrl.SearchController());

  final AuthenticateController authController =
      Get.put(AuthenticateController());

  @override
  void dispose() {
    Get.delete<ctrl.SearchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUserBuyer = authController.getUserType() == "Buyer" ? true : false;
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
                    if (productController.isLoading.value) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.secondaryColor,
                          ),
                        ),
                      );
                    } else if (searchController.searchedProducts.isNotEmpty) {
                      return Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: searchController.searchedProducts.length,
                          itemBuilder: (ctx, i) {
                            final prod = searchController.searchedProducts[i];
                            return ProductsCard(
                              prod: prod,
                              controller: productController,
                              isUserBuyer: isUserBuyer,
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
                              isUserBuyer: isUserBuyer,
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
