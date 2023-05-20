import 'package:flutter/material.dart';

import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class FavoriteIcon extends StatefulWidget {
  final Product product;
  final ProductController productController;

  FavoriteIcon({required this.product, required this.productController});

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorite = false;

  @override
  void initState() {
    _getFavStatus();
    super.initState();
  }

  void _getFavStatus() async {
    bool favStatus =
        await widget.productController.getFavoriteStatus(widget.product.id);
    setState(() {
      isFavorite = favStatus;
    });
  }

  void _toggleFavStatus() async {
    widget.productController.toggleFavoriteStatus(widget.product);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _toggleFavStatus(),
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
    );
  }
}
