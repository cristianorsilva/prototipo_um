import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/helpers/layout_common_functions_keys.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_receipt_keys.dart';

class LayoutCommonFunctionsScreen {
  Finder visibilityCircularProgressIndicator;

  LayoutCommonFunctionsScreen._({required this.visibilityCircularProgressIndicator});

  static final LayoutCommonFunctionsScreen _finders = LayoutCommonFunctionsScreen._(
      visibilityCircularProgressIndicator: find.byKey(const Key(LayoutCommonFunctionsKeys.visibilityCircularProgressIndicator)));


  static Future<void> pumpCircularProgressIndicatorBeVisible(WidgetTester tester) async {
    Visibility visibility = tester.widget(LayoutCommonFunctionsScreen._finders.visibilityCircularProgressIndicator) as Visibility;

  }


  static Future<void> waitCircularProgressIndicatorBeVisible(WidgetTester tester) async {
    bool isVisible = false;
    int count = 0;
    Visibility visibility = tester.widget(LayoutCommonFunctionsScreen._finders.visibilityCircularProgressIndicator) as Visibility;
    isVisible = visibility.visible;
    print('Iniciou como visivel? $isVisible');
    while (!isVisible && count < 20) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        isVisible = visibility.visible;
        count++;
      });
    }
    print('Terminou como visivel? $isVisible');
    if (!isVisible) {
      throw TestFailure('The loading did not appear!');
    }
  }

  static Future<void> waitCircularProgressIndicatorBeInVisible(WidgetTester tester) async {
    bool isVisible = false;
    int count = 0;
    Visibility visibility = tester.widget(LayoutCommonFunctionsScreen._finders.visibilityCircularProgressIndicator) as Visibility;
    isVisible = visibility.visible;
    print('Iniciou como visivel? $isVisible');
    while (isVisible && count < 50) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        isVisible = visibility.visible;
        count++;
      });
    }
    print('Terminou como visivel? $isVisible');
    if (isVisible) {
      throw TestFailure('The loading did not appear!');
    }
  }
}
