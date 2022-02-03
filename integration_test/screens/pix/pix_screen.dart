import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/pix/pix_keys.dart';

class PixScreen {
  Finder inkWellPixTransfer;
  Finder inkWellPixDeposit;
  Finder inkWellPixCopyPaste;
  Finder inkWellPixQRPayment;
  Finder inkWellPixMyKeys;
  Finder inkWellPixFavorites;

  PixScreen._({
    required this.inkWellPixTransfer,
    required this.inkWellPixDeposit,
    required this.inkWellPixCopyPaste,
    required this.inkWellPixQRPayment,
    required this.inkWellPixMyKeys,
    required this.inkWellPixFavorites,
  });

  static final PixScreen _finders = PixScreen._(
    inkWellPixTransfer: find.byKey(const Key(PixKeys.inkWellPixTransfer)),
    inkWellPixDeposit: find.byKey(const Key(PixKeys.inkWellPixDeposit)),
    inkWellPixCopyPaste: find.byKey(const Key(PixKeys.inkWellPixCopyPaste)),
    inkWellPixQRPayment: find.byKey(const Key(PixKeys.inkWellPixQRPayment)),
    inkWellPixMyKeys: find.byKey(const Key(PixKeys.inkWellPixMyKeys)),
    inkWellPixFavorites: find.byKey(const Key(PixKeys.inkWellPixFavorites)),
  );

  static Future<void> tapPixTransfer(WidgetTester tester) async {
    await tester.tap(PixScreen._finders.inkWellPixTransfer);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

  static Future<void> tapMyKeys(WidgetTester tester) async {
    await tester.tap(PixScreen._finders.inkWellPixMyKeys);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }
}
