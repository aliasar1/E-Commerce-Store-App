import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart' as ctrl;
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';
import 'add_product_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/sellerHomeScreen';

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
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
              Obx(() {
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
              }),
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
