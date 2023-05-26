import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/utils.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key, required this.authController}) : super(key: key);

  static const String routeName = '/cartScreen';

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
