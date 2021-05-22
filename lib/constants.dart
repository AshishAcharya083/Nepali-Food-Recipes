import 'package:flutter/material.dart';

const Color myPrimaryColor = Color(0xFFFFc529);
const Color mySecondaryColor = Color(0xFFFD7A50);
const Color myDarkColor = Color(0xFF201F1D);

final InputDecoration kTextFieldInputDecoration = InputDecoration(
  fillColor: Colors.grey.withOpacity(0.15),
  filled: true,
  focusColor: myPrimaryColor,
  focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: const BorderSide(
        color: Color(0xFFFFc529),
      )),
  isDense: true,
  contentPadding: EdgeInsets.all(12),
  enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      // const BorderSide(color: Color(0xFFFD7A50)),
      borderRadius: BorderRadius.all(Radius.circular(20))),
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xFFFFc529)),
    borderRadius: BorderRadius.circular(20),
  ),
  prefixIcon: Icon(
    Icons.search,
    color: myPrimaryColor,
  ),
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'Search for Recipes',
);
