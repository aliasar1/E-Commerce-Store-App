import 'package:e_commerce_shopping_app/controllers/auth_controller.dart';
import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:e_commerce_shopping_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/cart_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/buyer_home_drawer.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key, required this.authController}) : super(key: key);

  final AuthenticateController authController;
  final CartController cartController = Get.put(CartController());

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Txt(
                  textAlign: TextAlign.start,
                  text: StringsManager.myCartTxt,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.headerFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
              ),
              const SizedBox(height: 12),
              GetX<CartController>(
                init: cartController,
                builder: (cartController) {
                  if (cartController.isLoading.value) {
                    return Container();
                  } else {
                    return buildTotalBar(cartController.totalAmount);
                  }
                },
              ),
              Expanded(
                child: GetX<CartController>(
                  init: cartController,
                  builder: (cartController) {
                    if (cartController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.secondaryColor,
                        ),
                      );
                    } else if (cartController.cartItems.isNotEmpty) {
                      final items = cartController.cartItems;
                      return ListView.builder(
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (ctx, i) {
                          final item = items[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: MarginManager.marginS * 0.8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: ColorsManager.secondaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: FittedBox(
                                    child: Txt(
                                      text:
                                          '\$ ${item.price.toStringAsFixed(1)}',
                                      fontWeight: FontWeightManager.medium,
                                      color: ColorsManager.whiteColor,
                                      fontSize: FontSize.subTitleFontSize,
                                      fontFamily:
                                          FontsManager.fontFamilyPoppins,
                                    ),
                                  ),
                                ),
                              ),
                              title: Txt(
                                text: item.name.capitalizeFirstOfEach,
                                fontWeight: FontWeightManager.medium,
                                color: ColorsManager.primaryColor,
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                              subtitle: Txt(
                                text:
                                    'Total: \$${(item.price * item.quantity)}',
                                color:
                                    ColorsManager.primaryColor.withOpacity(0.7),
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                              trailing: Text('${item.quantity} x'),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: EmptyCartTemplate(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTotalBar(double totalAmount) {
    return Row(
      children: [
        const Expanded(
          child: Txt(
            text: "Total",
            color: ColorsManager.primaryColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.titleFontSize,
            fontWeight: FontWeightManager.medium,
          ),
        ),
        Chip(
          backgroundColor: ColorsManager.secondaryColor,
          label: Txt(
            text: totalAmount.toStringAsFixed(1),
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.textFontSize,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            // if (cart.items.isNotEmpty) {
            //   Provider.of<Orders>(context,
            //           listen: false)
            //       .addOrder(
            //     cart.items.values.toList(),
            //     cart.totalAmount,
            //   );
            //   cart.clear();
            // } else {
            //   ScaffoldMessenger.of(context)
            //       .hideCurrentSnackBar();
            //   ScaffoldMessenger.of(context)
            //       .showSnackBar(
            //     const SnackBar(
            //       content: Text(
            //         'Add products to cart first to order.',
            //       ),
            //       duration: Duration(seconds: 2),
            //     ),
            //   );
            // }
          },
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(ColorsManager.secondaryColor),
          ),
          child: const Txt(
            text: 'ORDER NOW',
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.subTitleFontSize * 1.1,
          ),
        ),
      ],
    );
  }
}

class EmptyCartTemplate extends StatelessWidget {
  const EmptyCartTemplate({
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
            'assets/images/add_to_cart.svg',
            height: SizeManager.svgImageSize,
            width: SizeManager.svgImageSize,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Txt(
              text: "No products are added to cart yet.",
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
