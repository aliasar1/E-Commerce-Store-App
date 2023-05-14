import 'package:e_commerce_shopping_app/managers/colors_manager.dart';
import 'package:e_commerce_shopping_app/models/product_model.dart';
import 'package:e_commerce_shopping_app/views/add_product_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.scaffoldBgColor,
        drawer: const SellerHomeDrawer(),
        appBar: AppBar(
          backgroundColor: ColorsManager.scaffoldBgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorsManager.secondaryColor),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
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
                          return ProductsCard(prod: prod);
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/no_product_found.svg',
                            height: SizeManager.splashIconSize,
                            width: SizeManager.splashIconSize,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Txt(
                            textAlign: TextAlign.center,
                            text: StringsManager.noProducttTxt,
                            fontWeight: FontWeightManager.bold,
                            fontSize: FontSize.titleFontSize,
                            fontFamily: FontsManager.fontFamilyPoppins,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return productController.products.isNotEmpty
                        ? Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10.0),
                              itemCount: productController.products.length,
                              itemBuilder: (ctx, i) {
                                final prod = productController.products[i];
                                return ProductsCard(prod: prod);
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          )
                        : const AddProductTemplate();
                  }
                },
              ),
            ],
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
  });

  final Product prod;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Image.network(
            prod.imageUrl,
            height: 80,
          ),
          const SizedBox(height: 10),
          Text(
            prod.name.capitalizeFirst!,
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
          CustomButton(
            color: ColorsManager.secondaryColor,
            textColor: ColorsManager.scaffoldBgColor,
            text: "Add Products Now!",
            onPressed: () async {
              Get.dialog(
                AlertDialog(
                  title: const Text(
                    'Add Event',
                    style: TextStyle(
                      color: ColorsManager.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.titleFontSize,
                    ),
                  ),
                  content: const Text("ads"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            },
            hasInfiniteWidth: true,
          ),
        ],
      ),
    );
  }
}
