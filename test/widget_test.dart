import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/main.dart';

void main() {
  testWidgets("Pumping widgets", (WidgetTester tester) async {
    tester.pumpWidget(MyApp());
  });
}
