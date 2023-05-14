import 'package:flutter/material.dart';

import '../utils/exports/managers_exports.dart';

class CustomSearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmit;

  const CustomSearchWidget(
      {Key? key, this.controller, this.validator, this.onFieldSubmit})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchWidgetState createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorsManager.whiteColor,
      ),
      child: TextFormField(
        cursorColor: ColorsManager.secondaryColor,
        controller: widget.controller,
        onFieldSubmitted: widget.onFieldSubmit,
        onChanged: widget.onFieldSubmit,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: ColorsManager.secondaryColor,
          ),
          hintText: 'Search for...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
