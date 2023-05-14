import 'package:e_commerce_shopping_app/widgets/cutom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';
import '../widgets/underline_textform_field.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key? key}) : super(key: key);

  final productController = Get.put(ProductController());

  // List<String> category = [
  //   'Clothes',
  //   'Watches',
  //   'Shoes',
  //   'Cosmetics And Body Care',
  //   'Food and Beverage',
  //   'Furniture and Decor',
  //   'Health and Wellness',
  //   'Household Items',
  //   'Media',
  //   'Pet Care',
  //   'Office Equipment',
  //   'Others',
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.scaffoldBgColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
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
          backgroundColor: ColorsManager.scaffoldBgColor,
          elevation: 0,
          title: const Txt(
            text: "Add Product",
            color: ColorsManager.primaryColor,
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
                    label: "Product Name",
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
                    child: const Txt(
                      text: "Product Image",
                      textAlign: TextAlign.start,
                      color: ColorsManager.primaryColor,
                      fontFamily: FontsManager.fontFamilyPoppins,
                      fontSize: FontSize.subTitleFontSize * 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  Obx(
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
                                height: 100,
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
                    label: "Description",
                    controller: productController.productDescriptionController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 100,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kDescriptionNullError;
                      }
                      return null;
                    },
                  ),
                  UnderlineTextFormField(
                    label: "Price",
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
                    label: "Stock Quantity",
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
                      textColor: ColorsManager.scaffoldBgColor,
                      text: "Add",
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
                        productController.addProduct(
                          productController.productNameController.text.trim(),
                          productController.productDescriptionController.text
                              .trim(),
                          productController.productPriceController.text.trim(),
                          productController.productStockQuantityController.text
                              .trim(),
                        );
                      },
                      hasInfiniteWidth: true,
                    ),
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
