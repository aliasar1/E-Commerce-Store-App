import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/extension.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                child: Txt(
                  text: 'No',
                  color: isDarkMode
                      ? DarkColorsManager.whiteColor
                      : ColorsManager.primaryColor,
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
                  color: DarkColorsManager.whiteColor,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
              ),
            ),
          ),
          title: Txt(
            text: item.name.capitalizeFirstOfEach,
            fontWeight: FontWeightManager.medium,
            color: isDarkMode
                ? DarkColorsManager.whiteColor
                : ColorsManager.primaryColor,
            fontFamily: FontsManager.fontFamilyPoppins,
          ),
          subtitle: Txt(
            text: 'Total: Rs ${(item.price * item.quantity)}',
            color: isDarkMode
                ? DarkColorsManager.whiteColor.withOpacity(0.7)
                : ColorsManager.primaryColor.withOpacity(0.7),
            fontFamily: FontsManager.fontFamilyPoppins,
          ),
          trailing: Text('${item.quantity} x'),
        ),
      ),
    );
  }
}
