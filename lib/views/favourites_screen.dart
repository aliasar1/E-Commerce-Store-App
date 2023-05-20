import 'package:e_commerce_shopping_app/controllers/product_controller.dart';
import 'package:e_commerce_shopping_app/views/seller_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/auth_controller.dart';
import '../models/product_model.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/buyer_home_drawer.dart';
import '../widgets/custom_text.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  final AuthenticateController authController =
      Get.put(AuthenticateController());

  final ProductController prodController = Get.put(ProductController());

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
                    text: StringsManager.favouriteTxt,
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.headerFontSize,
                    fontFamily: FontsManager.fontFamilyPoppins,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<List<Product>>(
                  stream: prodController
                      .fetchFavoriteProducts(firebaseAuth.currentUser!.uid)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final favProducts = snapshot.data!;
                      if (favProducts.isNotEmpty) {
                        return Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: favProducts.length,
                            itemBuilder: (ctx, i) {
                              final prod = favProducts[i];
                              return ProductsCard(
                                prod: prod,
                                controller: prodController,
                                isUserBuyer: isUserBuyer,
                                isFav: true,
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
                      } else {
                        return const Column(
                          children: [
                            SizedBox(height: SizeManager.sizeXL * 3),
                            NoFavsTemplate(),
                          ],
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.secondaryColor,
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

class NoFavsTemplate extends StatelessWidget {
  const NoFavsTemplate({
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
            'assets/images/fav.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Txt(
              text: "You haven't marked any product as favourite yet.",
              fontFamily: FontsManager.fontFamilyPoppins,
              fontSize: FontSize.textFontSize,
              fontWeight: FontWeightManager.medium,
              textAlign: TextAlign.center,
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
