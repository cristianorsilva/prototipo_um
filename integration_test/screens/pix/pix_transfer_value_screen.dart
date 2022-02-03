import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_value_keys.dart';

class PixTransferValueScreen {
  Finder alertDialogTitle;
  Finder alertDialogMessage;
  Finder alertDialogButtonOk;
  Finder buttonArrowContinue;
  Finder textAvailableBalance;
  Finder inputTransferValue;

  PixTransferValueScreen._({
    required this.alertDialogTitle,
    required this.alertDialogMessage,
    required this.alertDialogButtonOk,
    required this.buttonArrowContinue,
    required this.textAvailableBalance,
    required this.inputTransferValue,
  });

  static final PixTransferValueScreen _finders = PixTransferValueScreen._(
    alertDialogTitle: find.byKey(const Key(PixTransferValueKeys.alertDialogTitle)),
    alertDialogMessage: find.byKey(const Key(PixTransferValueKeys.alertDialogMessage)),
    alertDialogButtonOk: find.byKey(const Key(PixTransferValueKeys.alertDialogButtonOk)),
    buttonArrowContinue: find.byKey(const Key(PixTransferValueKeys.buttonArrowContinue)),
    textAvailableBalance: find.byKey(const Key(PixTransferValueKeys.textAvailableBalance)),
    inputTransferValue: find.byKey(const Key(PixTransferValueKeys.inputTransferValue)),

  );

  static Future<void> informValueToTransfer(WidgetTester tester, String value) async {
    //enter the data
    await tester.enterText(PixTransferValueScreen._finders.inputTransferValue, value);
    await tester.pumpAndSettle();
  }

  static Future<void> tapIconContinue(WidgetTester tester) async{
    await tester.tap(PixTransferValueScreen._finders.buttonArrowContinue.last);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }
}
