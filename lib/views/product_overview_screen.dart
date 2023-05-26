import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/models_exports.dart';
import '../utils/exports/views_exports.dart';
import '../widgets/custom_text.dart';
import '../widgets/fav_icon.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen(
      {super.key,
      required this.product,
      required this.controller,
      this.isFav = false});

  static const String routeName = '/productOverviewScreen';

  final Product product;
  final ProductController controller;
  final bool isFav;

  final authController = Get.put(AuthenticateController());
  final cartController = Get.put(CartController());
  final inventoryController = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    final isUserBuyer = authController.getUserType() == "Buyer" ? true : false;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode
            ? DarkColorsManager.scaffoldBgColor
            : ColorsManager.scaffoldBgColor,
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: [
                      Hero(
                        tag: product.id,
                        child: Container(
                          color: ColorsManager.lightGreyColor.withOpacity(0.1),
                          height: Get.height * 0.35,
                          width: double.infinity,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: ColorsManager.secondaryColor,
                          ),
                          onPressed: () {
                            isUserBuyer
                                ? isFav
                                    ? Get.offAll(FavouriteScreen())
                                    : Get.offAll(const BuyerHomeScreen())
                                : Get.offAll(const SellerHomeScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: SizeManager.sizeXL,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: MarginManager.marginM),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Txt(
                                  text: controller.productName == ""
                                      ? product.name.capitalizeFirstOfEach
                                      : controller
                                          .productName.capitalizeFirstOfEach,
                                  fontWeight: FontWeightManager.bold,
                                  fontSize: FontSize.headerFontSize * 0.8,
                                  fontFamily: FontsManager.fontFamilyPoppins,
                                ),
                              ),
                              Txt(
                                text: "Rs ${product.price.toString()}",
                                fontWeight: FontWeightManager.semibold,
                                fontSize: FontSize.textFontSize,
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => Txt(
                              text: controller.productDescription == ""
                                  ? product.description.capitalize
                                  : controller.productDescription.capitalize,
                              fontWeight: FontWeightManager.medium,
                              fontSize: FontSize.textFontSize * 0.8,
                              fontFamily: FontsManager.fontFamilyPoppins,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: SizeManager.sizeL * 4,
                        ),
                        isUserBuyer
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: const Txt(
                                      text: 'Total Stock Left',
                                      fontWeight: FontWeightManager.medium,
                                      fontSize: FontSize.textFontSize,
                                      fontFamily:
                                          FontsManager.fontFamilyPoppins,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Txt(
                                      text: inventoryController
                                          .getProductStockQuantity(product.id)
                                          .toString(),
                                      fontWeight: FontWeightManager.bold,
                                      color: ColorsManager.secondaryColor,
                                      fontSize: FontSize.titleFontSize,
                                      fontFamily:
                                          FontsManager.fontFamilyPoppins,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: isUserBuyer
            ? null
            : SpeedDial(
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
                          backgroundColor: isDarkMode
                              ? DarkColorsManager.scaffoldBgColor
                              : ColorsManager.scaffoldBgColor,
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
                                style: TextStyle(
                                    color: ColorsManager.secondaryColor),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorsManager.secondaryColor)),
                              onPressed: () async {
                                controller.deleteProduct(product.id);
                                Get.offAll(const SellerHomeScreen());
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                    color: ColorsManager.backgroundColor),
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
                    onTap: () {
                      Get.to(AddProductScreen(
                        isEdit: true,
                        product: product,
                      ));
                    },
                  ),
                ],
              ),
        persistentFooterButtons:
            isUserBuyer && (firebaseAuth.currentUser!.uid != product.ownerId)
                ? [
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          color: isDarkMode
                              ? DarkColorsManager.whiteColor
                              : ColorsManager.lightGreyColor.withOpacity(0.3),
                          child: FavoriteIcon(
                            product: product,
                            productController: controller,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => product.stockQuantity == 0
                                ? null
                                : cartController.addToCart(
                                    product.id,
                                    product.name,
                                    product.price.toString(),
                                    product.ownerId),
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              color: ColorsManager.secondaryColor,
                              child: Txt(
                                text: product.stockQuantity == 0
                                    ? "Out of Stock"
                                    : "Add to cart",
                                color: ColorsManager.scaffoldBgColor,
                                fontWeight: FontWeightManager.bold,
                                fontSize: FontSize.titleFontSize * 0.75,
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                : null,
      ),
    );
  }
}
