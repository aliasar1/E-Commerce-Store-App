import 'package:e_commerce_shopping_app/controllers/auth_controller.dart';
import 'package:e_commerce_shopping_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/cart_controller.dart';
import '../controllers/orders_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/utils.dart';
import '../widgets/buyer_home_drawer.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key, required this.authController}) : super(key: key);

  final AuthenticateController authController;
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());

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
                    return buildTotalBar(cartController, context);
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
                          return CartItemCard(
                            item: item,
                            cartController: cartController,
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

  Widget buildTotalBar(CartController controller, BuildContext context) {
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
            text: controller.total.toStringAsFixed(1),
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.textFontSize,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () async {
            if (controller.cartItems.isNotEmpty) {
              Utils.showLoading(context);
              await orderController.placeOrder(
                  controller.cartItems, controller.total);
              controller.clear();
            } else {
              Get.snackbar(
                'Failed!',
                'Add items first to place an order.',
              );
            }
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
