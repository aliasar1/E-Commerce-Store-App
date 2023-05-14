import 'package:e_commerce_shopping_app/controllers/auth_controller.dart';
import 'package:e_commerce_shopping_app/managers/colors_manager.dart';
import 'package:e_commerce_shopping_app/models/product_model.dart';
import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:e_commerce_shopping_app/views/add_product_screen.dart';
import 'package:e_commerce_shopping_app/views/product_overview_screen.dart';
import 'package:e_commerce_shopping_app/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutom_button.dart';
import '../widgets/seller_home_drawer.dart';
import '../controllers/search_controller.dart' as ctrl;

class SellerHomeScreen extends StatelessWidget {
  SellerHomeScreen({super.key});

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
        drawer: SellerHomeDrawer(
          controller: authController,
        ),
        appBar: AppBar(
          backgroundColor: ColorsManager.scaffoldBgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorsManager.secondaryColor),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Txt(
                    textAlign: TextAlign.start,
                    text: StringsManager.myProductsTxt,
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.headerFontSize,
                    fontFamily: FontsManager.fontFamilyPoppins,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomSearchWidget(
                  onFieldSubmit: (value) {
                    searchController.searchProduct(value.trim());
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(
                  () {
                    if (searchController.searchedProducts.isNotEmpty) {
                      return Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: searchController.searchedProducts.length,
                          itemBuilder: (ctx, i) {
                            final prod = searchController.searchedProducts[i];
                            return firebaseAuth.currentUser!.uid == prod.ownerId
                                ? ProductsCard(
                                    prod: prod,
                                    controller: productController,
                                  )
                                : Container();
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
                          SizedBox(
                            height: SizeManager.sizeXL * 3,
                          ),
                          AddProductTemplate(),
                        ],
                      );
                    } else {
                      return Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: productController.products.length,
                          itemBuilder: (ctx, i) {
                            final prod = productController.products[i];
                            return firebaseAuth.currentUser!.uid == prod.ownerId
                                ? ProductsCard(
                                    prod: prod,
                                    controller: productController,
                                  )
                                : Container();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddProductScreen(), arguments: [productController]);
          },
          backgroundColor: ColorsManager.secondaryColor,
          child: const Icon(
            Icons.add,
            color: ColorsManager.whiteColor,
          ),
        ),
      ),
    );
  }
}

class ProductsCard extends StatelessWidget {
  const ProductsCard({
    super.key,
    required this.prod,
    required this.controller,
  });

  final Product prod;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          ProductOverviewScreen(
            product: prod,
            controller: controller,
          ),
        );
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: prod.id,
              child: Image.network(
                prod.imageUrl,
                height: 80,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              prod.name.capitalizeFirstOfEach,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '\$ ${prod.price}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductTemplate extends StatelessWidget {
  const AddProductTemplate({
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
            'assets/images/add_product.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Txt(
              text: "You haven't added any product.",
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
