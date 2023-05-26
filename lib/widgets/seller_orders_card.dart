import 'dart:math';

import 'package:e_commerce_shopping_app/models/order_model.dart';
import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart_item.dart';
import '../models/user_model.dart';
import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';

class SellerOrderCard extends StatefulWidget {
  final OrderItem order;
  final User buyer;

  const SellerOrderCard(this.order, {super.key, required this.buyer});

  @override
  _SellerOrderCardState createState() => _SellerOrderCardState();
}

class _SellerOrderCardState extends State<SellerOrderCard> {
  var _expanded = false;

  double calculateTotal(List<CartItem> cartItems) {
    double total = 0;
    for (var cartItem in cartItems) {
      double productTotal = cartItem.quantity * cartItem.price;
      total += productTotal;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateTotal(widget.order.products);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: MarginManager.marginS * 0.8),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorsManager.lightSecondaryColor,
                                  ),
                                  child: Image.network(
                                    widget.buyer.profilePhoto == ""
                                        ? 'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'
                                        : widget.buyer.profilePhoto,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Txt(
                                text: widget.buyer.name,
                                fontWeight: FontWeightManager.bold,
                                color: ColorsManager.primaryColor,
                                fontSize: FontSize.textFontSize,
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Txt(
                                text: widget.buyer.email,
                                fontWeight: FontWeightManager.regular,
                                color: ColorsManager.primaryColor,
                                fontSize: FontSize.subTitleFontSize,
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                              Txt(
                                text: widget.buyer.phone,
                                fontWeight: FontWeightManager.regular,
                                color: ColorsManager.primaryColor,
                                fontSize: FontSize.subTitleFontSize,
                                fontFamily: FontsManager.fontFamilyPoppins,
                              ),
                              Center(
                                child: Txt(
                                  textAlign: TextAlign.center,
                                  text: widget.buyer.address,
                                  fontWeight: FontWeightManager.regular,
                                  color: ColorsManager.primaryColor,
                                  fontSize: FontSize.subTitleFontSize,
                                  fontFamily: FontsManager.fontFamilyPoppins,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: ClipOval(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManager.lightSecondaryColor,
                    ),
                    child: Image.network(
                      widget.buyer.profilePhoto == ""
                          ? "'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'"
                          : widget.buyer.profilePhoto,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.whiteColor,
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
                          Icons.person,
                          size: 40,
                          color: ColorsManager.whiteColor,
                        );
                      },
                    ),
                  ),
                ),
              ),
              title: Txt(
                text: 'Rs ${total.toStringAsFixed(2)}',
                fontWeight: FontWeightManager.medium,
                color: ColorsManager.secondaryColor,
                fontSize: FontSize.textFontSize,
                fontFamily: FontsManager.fontFamilyPoppins,
              ),
              subtitle: Txt(
                text: DateFormat('MMMM d, yyyy hh:mm a')
                    .format(widget.order.dateTime),
                color: ColorsManager.primaryColor,
                fontSize: FontSize.subTitleFontSize,
                fontFamily: FontsManager.fontFamilyPoppins,
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: ColorsManager.secondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          if (_expanded)
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: MarginManager.marginS * 0.8,
                  horizontal: MarginManager.marginM),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Txt(
                            text: prod.name.capitalizeFirstOfEach,
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeightManager.semibold,
                            fontSize: FontSize.titleFontSize * 0.6,
                            fontFamily: FontsManager.fontFamilyPoppins,
                          ),
                          Txt(
                            text: '${prod.quantity}x Rs ${prod.price}',
                            color: ColorsManager.primaryColor.withOpacity(0.7),
                            fontSize: FontSize.titleFontSize * 0.6,
                            fontFamily: FontsManager.fontFamilyPoppins,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
