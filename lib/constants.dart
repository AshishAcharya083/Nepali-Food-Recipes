import 'package:flutter/material.dart';

// const Color myPrimaryColor = Color(0xFFFFc529);

const Color kDarkColor = Color(0xFF201F1D);
const Color kGreyColor = Color(0xFFD7D7D7);
const Color kPinkColor = Color(0xFFFF94A1);

///new color pallets
const Color myPrimaryColor = Color(0xFFFFC400);
const Color kDarkGreenColor = Color(0xFF003C2D);
const Color kLightGreenColor = Color(0xFF609970);
const Color kOrangeColor = Color(0xFFFF9B33);
const Color kSecondaryColor = Color(0xFFFD7A50);

const List<Color> kCardColors = [myPrimaryColor, kSecondaryColor, kPinkColor];
const TextStyle kFormHeadingStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w700);

InputDecoration kInputDecoration = InputDecoration(
  fillColor: Colors.grey.withOpacity(0.15),
  filled: true,
  focusColor: myPrimaryColor,
  focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: const BorderSide(
        color: Color(0xFFFFc529),
      )),
  isDense: true,
  contentPadding: EdgeInsets.all(12),
  enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      // const BorderSide(color: Color(0xFFFD7A50)),
      borderRadius: BorderRadius.all(Radius.circular(15))),
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xFFFFc529)),
    borderRadius: BorderRadius.circular(15),
  ),
  prefixIcon: Icon(Icons.search),
  hintStyle: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 1.2),
  hintText: 'Search for Recipe',
);
