import 'package:e_commerce_shopping_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/addProductScreen';

  const AddProductScreen({Key? key, this.isEdit = false, this.product})
      : super(key: key);

  final bool isEdit;
  final Product? product;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productController = Get.put(ProductController());

  @override
  void initState() {
    if (widget.isEdit) {
      productController.productNameController.text =
          widget.product!.name.capitalizeFirstOfEach;
      productController.productDescriptionController.text =
          widget.product!.description;
      productController.productStockQuantityController.text =
          widget.product!.stockQuantity.toString();
      productController.productPriceController.text =
          widget.product!.price.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode
            ? DarkColorsManager.scaffoldBgColor
            : ColorsManager.scaffoldBgColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ColorsManager.secondaryColor,
            ),
            onPressed: () {
              productController.resetFields();
              Get.back();
            },
          ),
          backgroundColor: isDarkMode
              ? DarkColorsManager.scaffoldBgColor
              : ColorsManager.scaffoldBgColor,
          elevation: 0,
          title: Txt(
            text: widget.isEdit
                ? StringsManager.editProdTxt
                : StringsManager.addProdTxt,
            color: isDarkMode
                ? DarkColorsManager.whiteColor
                : ColorsManager.primaryColor,
            fontFamily: FontsManager.fontFamilyPoppins,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: ColorsManager.secondaryColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
            child: Form(
              key: productController.addFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: SizeManager.sizeSemiM,
                  ),
                  UnderlineTextFormField(
                    label: StringsManager.prodNameTxt,
                    controller: productController.productNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 20,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kProductNameNullError;
                      }
                      return null;
                    },
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Txt(
                      text: StringsManager.prodImgTxt,
                      textAlign: TextAlign.start,
                      color: isDarkMode
                          ? DarkColorsManager.whiteColor
                          : ColorsManager.primaryColor,
                      fontFamily: FontsManager.fontFamilyPoppins,
                      fontSize: FontSize.subTitleFontSize * 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  widget.isEdit
                      ? Obx(
                          () => GestureDetector(
                            onTap: () {
                              productController.pickImage();
                            },
                            child: productController.posterPhoto != null
                                ? SizedBox(
                                    width: double.infinity,
                                    height: SizeManager.sizeXXXL,
                                    child: Image.file(
                                      productController.posterPhoto!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: SizeManager.sizeXXXL,
                                    child: Image.network(
                                      widget.product!.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        )
                      : Obx(
                          () {
                            return GestureDetector(
                              onTap: () => productController.pickImage(),
                              child: productController.posterPhoto != null
                                  ? Image.file(
                                      productController.posterPhoto!,
                                      fit: BoxFit.fill,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: SizeManager.sizeXXL,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        color: ColorsManager.secondaryColor,
                                      ),
                                    ),
                            );
                          },
                        ),
                  const SizedBox(
                    height: SizeManager.sizeS,
                  ),
                  UnderlineTextFormField(
                    label: StringsManager.descriptionTxt,
                    controller: productController.productDescriptionController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 300,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kDescriptionNullError;
                      }
                      return null;
                    },
                  ),
                  UnderlineTextFormField(
                    label: StringsManager.priceTxt,
                    controller: productController.productPriceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kPriceEmptyError;
                      } else if (int.parse(value) <= 0) {
                        return ErrorManager.kInvalidPriceError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: SizeManager.sizeS,
                  ),
                  UnderlineTextFormField(
                    label: StringsManager.stockQtyTxt,
                    controller:
                        productController.productStockQuantityController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kStockEmptyError;
                      } else if (int.parse(value) <= 0) {
                        return ErrorManager.kInvalidStockError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: SizeManager.sizeL * 2,
                  ),
                  Obx(
                    () => CustomButton(
                      color: ColorsManager.secondaryColor,
                      textColor: ColorsManager.whiteColor,
                      text: widget.isEdit ? "Edit" : "Add",
                      buttonType: ButtonType.loading,
                      loadingWidget: productController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: ColorsManager.scaffoldBgColor,
                              ),
                            )
                          : null,
                      onPressed: () {
                        final name =
                            productController.productNameController.text.trim();
                        final description = productController
                            .productDescriptionController.text
                            .trim();
                        final price = productController
                            .productPriceController.text
                            .trim();
                        final stock = productController
                            .productStockQuantityController.text
                            .trim();
                        if (widget.isEdit) {
                          productController.updateProduct(
                              widget.product!.id,
                              name.toLowerCase(),
                              description,
                              price,
                              stock,
                              widget.product!.imageUrl,
                              productController.posterPhoto,
                              productController);
                        } else {
                          productController.addProduct(
                              name, description, price, stock);
                        }
                      },
                      hasInfiniteWidth: true,
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeXL,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
