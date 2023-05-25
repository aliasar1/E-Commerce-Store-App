import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/orders_controller.dart';
import '../models/user_model.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';
import '../widgets/seller_home_drawer.dart';
import '../widgets/seller_orders_card.dart';
import 'orders_history_screen.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final AuthenticateController authController =
      Get.put(AuthenticateController());
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
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
                  text: StringsManager.ordersPlacedTxt,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.headerFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () {
                  if (orderController.isLoading.value) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.secondaryColor,
                        ),
                      ),
                    );
                  } else if (orderController.sellerOrders.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: orderController.sellerOrders.length,
                        itemBuilder: (ctx, i) {
                          return SellerOrderCard(
                            orderController.sellerOrders[i],
                            buyer:
                                User.fromMap(orderController.userOrderInfo[i]),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Column(
                      children: [
                        SizedBox(height: SizeManager.sizeXL * 3),
                        NoOrdersTemplate(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
