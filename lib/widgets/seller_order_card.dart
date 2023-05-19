import 'dart:math';

import 'package:e_commerce_shopping_app/models/order_model.dart';
import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';

class SellerOrderCard extends StatefulWidget {
  final OrderItem order;

  SellerOrderCard(this.order, {super.key});

  @override
  _SellerOrderCardState createState() => _SellerOrderCardState();
}

class _SellerOrderCardState extends State<SellerOrderCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: MarginManager.marginS * 0.8),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Txt(
              text: '\$${widget.order.amount.toStringAsFixed(2)}',
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
                            text: '${prod.quantity}x \$ ${prod.price}',
                            color: ColorsManager.primaryColor.withOpacity(0.7),
                            fontSize: FontSize.titleFontSize * 0.6,
                            fontFamily: FontsManager.fontFamilyPoppins,
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}