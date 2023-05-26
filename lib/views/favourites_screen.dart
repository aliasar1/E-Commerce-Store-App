import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  static const String routeName = '/favouriteScreen';

  final AuthenticateController authController =
      Get.put(AuthenticateController());

  final ProductController prodController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isUserBuyer = authController.getUserType() == "Buyer" ? true : false;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode
            ? DarkColorsManager.scaffoldBgColor
            : ColorsManager.scaffoldBgColor,
        drawer: BuyerHomeDrawer(controller: authController),
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? DarkColorsManager.scaffoldBgColor
              : ColorsManager.scaffoldBgColor,
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
                  child: Txt(
                    textAlign: TextAlign.start,
                    text: StringsManager.favouriteTxt,
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.headerFontSize,
                    color: isDarkMode
                        ? DarkColorsManager.whiteColor
                        : ColorsManager.primaryColor,
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
