import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';
import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.cartController,
  });

  final CartItem item;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: ColorsManager.secondaryColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Txt(
                  text: 'No',
                  color: ColorsManager.primaryColor,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: const Txt(
                  text: 'Yes',
                  color: ColorsManager.secondaryColor,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cartController.removeFromCart(item.productId);
      },
      child: Card(
        margin:
            const EdgeInsets.symmetric(vertical: MarginManager.marginS * 0.8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorsManager.secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Txt(
                  text: 'Rs ${item.price.toStringAsFixed(1)}',
                  fontWeight: FontWeightManager.medium,
                  color: ColorsManager.whiteColor,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
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
            text: 'Total: Rs ${(item.price * item.quantity)}',
            color: ColorsManager.primaryColor.withOpacity(0.7),
            fontFamily: FontsManager.fontFamilyPoppins,
          ),
          trailing: Text('${item.quantity} x'),
        ),
      ),
    );
  }
}
