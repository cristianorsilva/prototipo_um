import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_receipt_keys.dart';

class PixTransferReceiptScreen {
  Finder singleChildScrowViewMain;

  Finder gestureDetectorClose;
  Finder gestureDetectorShare;

  Finder textReceiptTitle;

  Finder textTransferDate;
  Finder textTransferValue;
  Finder textTransferType;

  Finder textRecipientFullUserName;
  Finder textRecipientDocumentNumber;
  Finder textRecipientBankName;
  Finder textRecipientAgencyNumber;
  Finder textRecipientAccountNumber;
  Finder textRecipientAccountType;

  Finder textSenderFullUserName;
  Finder textSenderDocumentNumber;
  Finder textSenderBankName;
  Finder textSenderAgencyNumber;
  Finder textSenderAccountNumber;
  Finder textSenderAccountType;

  Finder textTransactionID;

  PixTransferReceiptScreen._({
    required this.singleChildScrowViewMain,
    required this.gestureDetectorClose,
    required this.gestureDetectorShare,
    required this.textReceiptTitle,
    required this.textTransferDate,
    required this.textTransferValue,
    required this.textTransferType,
    required this.textRecipientFullUserName,
    required this.textRecipientDocumentNumber,
    required this.textRecipientBankName,
    required this.textRecipientAgencyNumber,
    required this.textRecipientAccountNumber,
    required this.textRecipientAccountType,
    required this.textSenderFullUserName,
    required this.textSenderDocumentNumber,
    required this.textSenderBankName,
    required this.textSenderAgencyNumber,
    required this.textSenderAccountNumber,
    required this.textSenderAccountType,
    required this.textTransactionID,
  });

  static final PixTransferReceiptScreen _finders = PixTransferReceiptScreen._(
    singleChildScrowViewMain: find.byKey(const Key(PixTransferReceiptKeys.singleChildScrowViewMain)),
    gestureDetectorClose: find.byKey(const Key(PixTransferReceiptKeys.gestureDetectorClose)),
    gestureDetectorShare: find.byKey(const Key(PixTransferReceiptKeys.gestureDetectorShare)),
    textReceiptTitle: find.byKey(const Key(PixTransferReceiptKeys.textReceiptTitle)),
    textTransferDate: find.byKey(const Key(PixTransferReceiptKeys.textTransferDate)),
    textTransferValue: find.byKey(const Key(PixTransferReceiptKeys.textTransferValue)),
    textTransferType: find.byKey(const Key(PixTransferReceiptKeys.textTransferType)),
    textRecipientFullUserName: find.byKey(const Key(PixTransferReceiptKeys.textRecipientFullUserName)),
    textRecipientDocumentNumber: find.byKey(const Key(PixTransferReceiptKeys.textRecipientDocumentNumber)),
    textRecipientBankName: find.byKey(const Key(PixTransferReceiptKeys.textRecipientBankName)),
    textRecipientAgencyNumber: find.byKey(const Key(PixTransferReceiptKeys.textRecipientAgencyNumber)),
    textRecipientAccountNumber: find.byKey(const Key(PixTransferReceiptKeys.textRecipientAccountNumber)),
    textRecipientAccountType: find.byKey(const Key(PixTransferReceiptKeys.textRecipientAccountType)),
    textSenderFullUserName: find.byKey(const Key(PixTransferReceiptKeys.textSenderFullUserName)),
    textSenderDocumentNumber: find.byKey(const Key(PixTransferReceiptKeys.textSenderDocumentNumber)),
    textSenderBankName: find.byKey(const Key(PixTransferReceiptKeys.textSenderBankName)),
    textSenderAgencyNumber: find.byKey(const Key(PixTransferReceiptKeys.textSenderAgencyNumber)),
    textSenderAccountNumber: find.byKey(const Key(PixTransferReceiptKeys.textSenderAccountNumber)),
    textSenderAccountType: find.byKey(const Key(PixTransferReceiptKeys.textSenderAccountType)),
    textTransactionID: find.byKey(const Key(PixTransferReceiptKeys.textTransactionID)),
  );

  static Future<void> dragClose(WidgetTester tester) async {
    await tester.dragUntilVisible(PixTransferReceiptScreen._finders.gestureDetectorClose.last,
        PixTransferReceiptScreen._finders.singleChildScrowViewMain.last, Offset.fromDirection(5.0));
    await tester.pumpAndSettle();
  }

  static Future<void> tapClose(WidgetTester tester) async {
    await tester.tap(PixTransferReceiptScreen._finders.gestureDetectorClose);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

  static Future<void> tapShare(WidgetTester tester) async {
    await tester.tap(PixTransferReceiptScreen._finders.gestureDetectorShare);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

  static Function checkReceiptTitle(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textReceiptTitle.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkTransferValue(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textTransferValue.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkTransferWhen(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textTransferDate.last) as Text;
      expect(text.data?.substring(0, 10), checkText);
    };
  }

  static Function checkTransferType(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textTransferType.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientUserName(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textRecipientFullUserName.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientDocumentNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textRecipientDocumentNumber.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientBankName(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textRecipientBankName.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientAgencyNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textRecipientAgencyNumber.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientAccountNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textRecipientAccountNumber.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkRecipientAccountType(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textRecipientAccountType.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkSenderUserName(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textSenderFullUserName.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkSenderDocumentNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textSenderDocumentNumber.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkSenderBankName(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textSenderBankName.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkSenderAgencyNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textSenderAgencyNumber.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkSenderAccountNumber(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textSenderAccountNumber.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkSenderAccountType(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textSenderAccountType.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkTransactionID(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(PixTransferReceiptScreen._finders.textTransactionID.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Future<void> dragTransactionID(WidgetTester tester) async {
    await tester.dragUntilVisible(PixTransferReceiptScreen._finders.textTransactionID.last,
        PixTransferReceiptScreen._finders.singleChildScrowViewMain.last, Offset.fromDirection(5.0));

    await tester.pumpAndSettle();
  }
}
