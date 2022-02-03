import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_recipient_keys.dart';
import 'package:prototipo_um/helpers/database/pix_key_type.dart';

class PixTransferRecipientScreen {
  Finder choiceChipPixKeyCPFCNPJ;
  Finder choiceChipPixKeyAleatory;
  Finder choiceChipPixKeyCellphone;
  Finder choiceChipPixKeyEmail;

  Finder buttonArrowContinue;

  Finder alertDialogTitle;
  Finder alertDialogMessage;
  Finder alertDialogButtonOk;

  Finder textValueTransfer;
  Finder inputPixKey;

  PixTransferRecipientScreen._({
    required this.choiceChipPixKeyCPFCNPJ,
    required this.choiceChipPixKeyAleatory,
    required this.choiceChipPixKeyCellphone,
    required this.choiceChipPixKeyEmail,
    required this.buttonArrowContinue,
    required this.alertDialogTitle,
    required this.alertDialogMessage,
    required this.alertDialogButtonOk,
    required this.textValueTransfer,
    required this.inputPixKey,
  });

  static final PixTransferRecipientScreen _finders = PixTransferRecipientScreen._(
    choiceChipPixKeyCPFCNPJ: find.byKey(const Key(PixTransferRecipientKeys.choiceChipPixKeyCPFCNPJ)),
    choiceChipPixKeyAleatory: find.byKey(const Key(PixTransferRecipientKeys.choiceChipPixKeyAleatory)),
    choiceChipPixKeyCellphone: find.byKey(const Key(PixTransferRecipientKeys.choiceChipPixKeyCellphone)),
    choiceChipPixKeyEmail: find.byKey(const Key(PixTransferRecipientKeys.choiceChipPixKeyEmail)),
    buttonArrowContinue: find.byKey(const Key(PixTransferRecipientKeys.buttonArrowContinue)),
    alertDialogTitle: find.byKey(const Key(PixTransferRecipientKeys.alertDialogTitle)),
    alertDialogMessage: find.byKey(const Key(PixTransferRecipientKeys.alertDialogMessage)),
    alertDialogButtonOk: find.byKey(const Key(PixTransferRecipientKeys.alertDialogButtonOk)),
    textValueTransfer: find.byKey(const Key(PixTransferRecipientKeys.textValueTransfer)),
    inputPixKey: find.byKey(const Key(PixTransferRecipientKeys.inputPixKey)),
  );

  static Future<void> selectPixKeyType(WidgetTester tester, EnumPixKeyType enumPixKeyType) async {
    switch (enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        await tester.tap(find.byKey(Key(PixTransferRecipientKeys.choiceChipPixKeyCPFCNPJ)));
        break;
      case EnumPixKeyType.chave_aleatoria:
        await tester.tap(find.byKey(Key(PixTransferRecipientKeys.choiceChipPixKeyAleatory)));
        break;
      case EnumPixKeyType.telefone:
        await tester.tap(find.byKey(Key(PixTransferRecipientKeys.choiceChipPixKeyCellphone)));
        break;
      case EnumPixKeyType.email:
        await tester.tap(find.byKey(Key(PixTransferRecipientKeys.choiceChipPixKeyEmail)));
        break;
    }

    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

  static Future<void> informPixKeyToTransfer(WidgetTester tester, String value) async {
    //enter the data
    await tester.enterText(PixTransferRecipientScreen._finders.inputPixKey, value);
    await tester.pumpAndSettle();
  }

  static Future<void> tapIconContinue(WidgetTester tester) async {
    await tester.tap(PixTransferRecipientScreen._finders.buttonArrowContinue.last);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

}
