import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/views_exports.dart';
import 'fav_icon.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
      child: Center(
        child: Stack(
          children: [
            Container(
              width: Get.width * 0.4,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? DarkColorsManager.cardBackgroundColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.5),
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
                      height: Get.height * 0.13,
                      width: Get.width * 0.4,
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
                  FittedBox(
                    child: Text(
                      prod.name.capitalizeFirstOfEach,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                            'Rs ${prod.price}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeightManager.medium,
                              color: isDarkMode
                                  ? DarkColorsManager.whiteColor
                                  : ColorsManager.primaryColor.withOpacity(0.8),
                            ),
                          ),
                          const Spacer(),
                          prod.stockQuantity != 0
                              ? GestureDetector(
                                  onTap: () {
                                    cartController.addToCart(prod.id, prod.name,
                                        prod.price.toString(), prod.ownerId);
                                  },
                                  child: const Icon(
                                    Icons.add_shopping_cart,
                                    color: ColorsManager.secondaryColor,
                                  ),
                                )
                              : const Icon(
                                  Icons.backspace,
                                  color: ColorsManager.secondaryColor,
                                ),
                        ],
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        'Rs ${prod.price}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeightManager.medium,
                          color: isDarkMode
                              ? DarkColorsManager.whiteColor
                              : ColorsManager.primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (prod.stockQuantity == 0)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  child: const Chip(
                    label: Text(
                      'Not Available',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: ColorsManager.secondaryColor,
                  ),
                ),
              ),
            if (isFav)
              Positioned(
                top: 10,
                right: 5,
                child:
                    FavoriteIcon(product: prod, productController: controller),
              ),
          ],
        ),
      ),
    );
  }
}
