import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

class StandardTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final int? maxLine;

  StandardTextField({this.hintText, this.controller, this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: TextField(
          maxLines: maxLine,
          cursorColor: kSecondaryColor,
          style: TextStyle(
              height: 1.5,
              letterSpacing: 1.2,
              fontFamily: 'Dosis-Bold',
              fontSize: 18),
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            focusColor: myPrimaryColor,
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: const BorderSide(
                  color: Color(0xFFFFc529),
                )),
            isDense: true,
            // contentPadding: EdgeInsets.all(12),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kGreyColor),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFFFc529)),
              borderRadius: BorderRadius.circular(15),
            ),
            hintStyle:
                TextStyle(color: Colors.grey, fontSize: 16, letterSpacing: 1.2),
            hintText: hintText,
          )),
    );
  }
}
