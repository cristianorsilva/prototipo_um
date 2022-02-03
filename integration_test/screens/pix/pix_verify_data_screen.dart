import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/pix/pix_verify_data_keys.dart';

class PixVerifyDataScreen {
  Finder singleChildScrowViewMain;
  Finder gestureDetectorChangeValue;
  Finder textTransferValue;
  Finder textRecipientFullUserName;
  Finder textTransferDate;
  Finder textTransferType;
  Finder textRecipientDocumentNumber;
  Finder textRecipientBankName;
  Finder textRecipientAgencyNumber;
  Finder textRecipientAccountNumber;

  Finder buttonTransfer;

  PixVerifyDataScreen._({
    required this.singleChildScrowViewMain,
    required this.gestureDetectorChangeValue,
    required this.textTransferValue,
    required this.textRecipientFullUserName,
    required this.textTransferDate,
    required this.textTransferType,
    required this.textRecipientDocumentNumber,
    required this.textRecipientBankName,
    required this.textRecipientAgencyNumber,
    required this.textRecipientAccountNumber,
    required this.buttonTransfer,
  });

  static final PixVerifyDataScreen _finders = PixVerifyDataScreen._(
    singleChildScrowViewMain: find.byKey(const Key(PixVerifyDataKeys.singleChildScrowViewMain)),
    gestureDetectorChangeValue: find.byKey(const Key(PixVerifyDataKeys.gestureDetectorChangeValue)),
    textTransferValue: find.byKey(const Key(PixVerifyDataKeys.textTransferValue)),
    textRecipientFullUserName: find.byKey(const Key(PixVerifyDataKeys.textRecipientFullUserName)),
    textTransferDate: find.byKey(const Key(PixVerifyDataKeys.textTransferDate)),
    textTransferType: find.byKey(const Key(PixVerifyDataKeys.textTransferType)),
    textRecipientDocumentNumber: find.byKey(const Key(PixVerifyDataKeys.textRecipientDocumentNumber)),
    textRecipientBankName: find.byKey(const Key(PixVerifyDataKeys.textRecipientBankName)),
    textRecipientAgencyNumber: find.byKey(const Key(PixVerifyDataKeys.textRecipientAgencyNumber)),
    textRecipientAccountNumber: find.byKey(const Key(PixVerifyDataKeys.textRecipientAccountNumber)),
    buttonTransfer: find.byKey(const Key(PixVerifyDataKeys.buttonTransfer)),
  );

  static Future<void> tapChangeValue(WidgetTester tester) async {
    await tester.tap(PixVerifyDataScreen._finders.gestureDetectorChangeValue);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

  static Future<void> tapButtonTransfer(WidgetTester tester) async {
    await tester.tap(PixVerifyDataScreen._finders.buttonTransfer);
    await tester.pumpAndSettle();
  }

  static Function checkTransferValue(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textTransferValue) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkTransferWhen(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textTransferDate) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkTransferType(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textTransferType) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientUserName(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textRecipientFullUserName) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientDocumentNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textRecipientDocumentNumber) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientBankName(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textRecipientBankName) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientAgencyNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textRecipientAgencyNumber) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientAccountNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixVerifyDataScreen._finders.textRecipientAccountNumber) as Text;
      expect(text.data, checkText);
    };
  }

  static Future<void> dragRecipientAccountNumber(WidgetTester tester) async {
    await tester.dragUntilVisible(PixVerifyDataScreen._finders.textRecipientAccountNumber.last,
        PixVerifyDataScreen._finders.singleChildScrowViewMain.last, Offset.fromDirection(5.0));
    await tester.pumpAndSettle();
  }
}
