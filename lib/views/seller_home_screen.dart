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

import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';
import '../widgets/fav_icon.dart';
import '../widgets/seller_home_drawer.dart';
import '../controllers/search_controller.dart' as ctrl;

class SellerHomeScreen extends StatelessWidget {
  SellerHomeScreen({Key? key}) : super(key: key);

  final ProductController productController = Get.put(ProductController());
  final ctrl.SearchController searchController =
      Get.put(ctrl.SearchController());
  final AuthenticateController authController =
      Get.put(AuthenticateController());

  @override
  Widget build(BuildContext context) {
    final isUserBuyer = authController.getUserType() == "Buyer" ? true : false;
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
                          return firebaseAuth.currentUser!.uid == prod.ownerId
                              ? ProductsCard(
                                  prod: prod,
                                  controller: productController,
                                  isUserBuyer: isUserBuyer,
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
                  } else if (productController.myProducts.isEmpty) {
                    return const Column(
                      children: [
                        SizedBox(height: SizeManager.sizeXL * 3),
                        AddProductTemplate(),
                      ],
                    );
                  } else {
                    return Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: productController.myProducts.length,
                        itemBuilder: (ctx, i) {
                          final prod = productController.myProducts[i];
                          return firebaseAuth.currentUser!.uid == prod.ownerId
                              ? ProductsCard(
                                  prod: prod,
                                  controller: productController,
                                  isUserBuyer: isUserBuyer,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(const AddProductScreen());
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
  ProductsCard({
    Key? key,
    required this.prod,
    required this.controller,
    required this.isUserBuyer,
    this.isFav = false,
  }) : super(key: key);

  final Product prod;
  final ProductController controller;
  final bool isUserBuyer;
  final bool isFav;
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          ProductOverviewScreen(
            product: prod,
            controller: controller,
            isFav: isFav,
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: 140,
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
                  child: SizedBox(
                    height: 100,
                    width: 140,
                    child: Image.network(
                      prod.imageUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.secondaryColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: ColorsManager.secondaryColor,
                        );
                      },
                    ),
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
                if (isUserBuyer &&
                    (firebaseAuth.currentUser!.uid != prod.ownerId))
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: MarginManager.marginS),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '\$ ${prod.price}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeightManager.medium,
                            color: ColorsManager.primaryColor.withOpacity(0.8),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            cartController.addToCart(prod.id, prod.name,
                                prod.price.toString(), prod.ownerId);
                          },
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: ColorsManager.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Center(
                    child: Text(
                      '\$ ${prod.price}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeightManager.medium,
                        color: ColorsManager.primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isFav)
            Positioned(
              top: 10,
              right: 25,
              child: FavoriteIcon(product: prod, productController: controller),
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
