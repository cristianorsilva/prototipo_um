import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prototipo_um/helpers/database/pix_key_type.dart';
import 'package:prototipo_um/main.dart' as app;
import 'package:intl/intl.dart';

import '../screens/home_screen.dart';
import '../screens/login_not_remembered_screen.dart';
import '../screens/pix/pix_screen.dart';
import '../screens/pix/pix_transfer_receipt_screen.dart';
import '../screens/pix/pix_transfer_recipient_screen.dart';
import '../screens/pix/pix_transfer_value_screen.dart';
import '../screens/pix/pix_verify_data_screen.dart';
import '../test_extensions.dart';
import '../test_utils.dart';

late IntegrationTestWidgetsFlutterBinding binding;
String dirFeature = "Feature Pix/";
String dirDateHour = "";
String dirTestName = "";

Future<void> main() async {
  setUpAll(() async {
    DateFormat formatter;
    formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    dirDateHour = formatter.format(DateTime.now()).replaceAll("/", "_").replaceAll(" ", "_").replaceAll(":", "_") + "/";

    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }
  });

  tearDown(() {});

  binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;

  group('Pix', () {});

  group('Pix Transfer', () {
    testWidgets(
        'TC 101 '
        'GIVEN I log in the app with success, '
        'AND I tap Pix '
        'AND I proceed with a Pix Transfer '
        'WHEN I reach "Dados de transferência" screen '
        'THEN I can validate the recipient"s data in screen',
        validateTransferDataScreen);

    testWidgets(
        'TC 102 '
        'GIVEN I log in the app with success, '
        'AND I tap Pix '
        'WHEN I perform a successful pix transfer '
        'THEN I can validate the recipient"s data in receipt screen '
        'AND I can validate the sender"s data in receipt screen '
        'AND the transfer date is today',
        validateReceiptScreen);

    testWidgets(
        'TC 103 '
        'GIVEN I log in the app with success, '
        'WHEN I tap Pix '
        'THEN I can perform a successful pix transfer ',
        successfulPixTransfer);
  });

  group('Minhas Chaves', () {});
}

Future<void> validateTransferDataScreen(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "1 - Validate Transfer Data Screen/";

  try {
    //performs login
    await LoginNotRememberedScreen.informUserAndPassword(tester, '92903540039', '172839');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.dragButtonLogin(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.tapButtonLogin(tester);

    //access pix screen and perform a transfer
    await HomeScreen.tapPix(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixScreen.tapPixTransfer(tester);
    await PixTransferValueScreen.informValueToTransfer(tester, '1,25');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixTransferValueScreen.tapIconContinue(tester);
    await PixTransferRecipientScreen.selectPixKeyType(tester, EnumPixKeyType.cpf_cnpj);
    await PixTransferRecipientScreen.informPixKeyToTransfer(tester, '97114700040');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixTransferRecipientScreen.tapIconContinue(tester);

    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    await PixVerifyDataScreen.dragRecipientAccountNumber(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    await tester.pumpAndSettle();

    //validates the transfer data:
    tester.checkExpectedTextOnTextWidgets({
      PixVerifyDataScreen.checkTransferValue(tester, 'R\$ 1,25'),
      PixVerifyDataScreen.checkTransferWhen(tester, 'Agora'),
      PixVerifyDataScreen.checkTransferType(tester, 'Pix'),
      PixVerifyDataScreen.checkRecipientUserName(tester, 'Joana Ferreira Schimidt'),
      PixVerifyDataScreen.checkRecipientDocumentNumber(tester, '***.147.000-**'),
      PixVerifyDataScreen.checkRecipientBankName(tester, 'Banco Solar'),
      PixVerifyDataScreen.checkRecipientAgencyNumber(tester, '2258-4'),
      PixVerifyDataScreen.checkRecipientAccountNumber(tester, '32542-3'),
    });
  } catch (e) {
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    rethrow;
  }
}

Future<void> validateReceiptScreen(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "2 - Validate Receipt Screen/";

  try {
    //performs login
    await LoginNotRememberedScreen.informUserAndPassword(tester, '92903540039', '172839');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.dragButtonLogin(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.tapButtonLogin(tester);

    //access pix screen and perform a transfer
    await HomeScreen.tapPix(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixScreen.tapPixTransfer(tester);
    await PixTransferValueScreen.informValueToTransfer(tester, '1,25');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixTransferValueScreen.tapIconContinue(tester);
    await PixTransferRecipientScreen.selectPixKeyType(tester, EnumPixKeyType.cpf_cnpj);
    await PixTransferRecipientScreen.informPixKeyToTransfer(tester, '97114700040');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixTransferRecipientScreen.tapIconContinue(tester);

    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    await PixVerifyDataScreen.dragRecipientAccountNumber(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    await tester.pumpAndSettle();

    await PixVerifyDataScreen.tapButtonTransfer(tester);

    //screenshot from the first part of screen
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    //scrolls the screen to make sure other elements are visible
    await PixTransferReceiptScreen.dragTransactionID(tester);
    //screenshot from the first part of screen
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    tester.checkExpectedTextOnTextWidgets({
      //check transfer
      PixTransferReceiptScreen.checkTransferValue(tester, 'R\$ 1,25'),
      PixTransferReceiptScreen.checkTransferWhen(tester, DateFormat('dd/MM/yyyy').format(DateTime.now())),
      PixTransferReceiptScreen.checkTransferType(tester, 'Pix'),
      //check recipient
      PixTransferReceiptScreen.checkRecipientUserName(tester, 'Joana Ferreira Schimidt'),
      PixTransferReceiptScreen.checkRecipientDocumentNumber(tester, '971.147.000-40'),
      PixTransferReceiptScreen.checkRecipientBankName(tester, 'Banco Solar'),
      PixTransferReceiptScreen.checkRecipientAgencyNumber(tester, '2258-4'),
      PixTransferReceiptScreen.checkRecipientAccountNumber(tester, '32542-3'),
      PixTransferReceiptScreen.checkRecipientAccountType(tester, 'Conta Corrente'),
      //check sender
      PixTransferReceiptScreen.checkSenderUserName(tester, 'João Carlos da Silva'),
      PixTransferReceiptScreen.checkSenderDocumentNumber(tester, '929.035.400-39'),
      PixTransferReceiptScreen.checkSenderBankName(tester, 'CrediBank'),
      PixTransferReceiptScreen.checkSenderAgencyNumber(tester, '0124-5'),
      PixTransferReceiptScreen.checkSenderAccountNumber(tester, '12452-6'),
      PixTransferReceiptScreen.checkSenderAccountType(tester, 'Conta Corrente'),
      //check transaction id
      PixTransferReceiptScreen.checkTransactionID(tester, 'E7565486895648s89657978BH'),
    });

    await PixTransferReceiptScreen.dragClose(tester);
    await PixTransferReceiptScreen.tapClose(tester);
  } catch (e) {
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    rethrow;
  }
}

Future<void> successfulPixTransfer(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "3 - Successful Pix Transfer/";

  try {
    //performs login
    await LoginNotRememberedScreen.informUserAndPassword(tester, '92903540039', '172839');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.dragButtonLogin(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.tapButtonLogin(tester);

    //access pix screen and perform a transfer
    await HomeScreen.tapPix(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixScreen.tapPixTransfer(tester);
    await PixTransferValueScreen.informValueToTransfer(tester, '1,25');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixTransferValueScreen.tapIconContinue(tester);
    await PixTransferRecipientScreen.selectPixKeyType(tester, EnumPixKeyType.cpf_cnpj);
    await PixTransferRecipientScreen.informPixKeyToTransfer(tester, '97114700040');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await PixTransferRecipientScreen.tapIconContinue(tester);

    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    await PixVerifyDataScreen.dragRecipientAccountNumber(tester);
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    await tester.pumpAndSettle();

    //validates the transfer data:
    tester.checkExpectedTextOnTextWidgets({
      PixVerifyDataScreen.checkTransferValue(tester, 'R\$ 1,25'),
      PixVerifyDataScreen.checkTransferWhen(tester, 'Agora'),
      PixVerifyDataScreen.checkTransferType(tester, 'Pix'),
      PixVerifyDataScreen.checkRecipientUserName(tester, 'Joana Ferreira Schimidt'),
      PixVerifyDataScreen.checkRecipientDocumentNumber(tester, '***.147.000-**'),
      PixVerifyDataScreen.checkRecipientBankName(tester, 'Banco Solar'),
      PixVerifyDataScreen.checkRecipientAgencyNumber(tester, '2258-4'),
      PixVerifyDataScreen.checkRecipientAccountNumber(tester, '32542-3'),
    });

    await PixVerifyDataScreen.tapButtonTransfer(tester);

    //screenshot from the first part of screen
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    //scrolls the screen to make sure other elements are visible
    await PixTransferReceiptScreen.dragTransactionID(tester);
    //screenshot from the first part of screen
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);

    tester.checkExpectedTextOnTextWidgets({
      //check transfer
      PixTransferReceiptScreen.checkTransferValue(tester, 'R\$ 1,25'),
      PixTransferReceiptScreen.checkTransferWhen(tester, DateFormat('dd/MM/yyyy').format(DateTime.now())),
      PixTransferReceiptScreen.checkTransferType(tester, 'Pix'),
      //check recipient
      PixTransferReceiptScreen.checkRecipientUserName(tester, 'Joana Ferreira Schimidt'),
      PixTransferReceiptScreen.checkRecipientDocumentNumber(tester, '971.147.000-40'),
      PixTransferReceiptScreen.checkRecipientBankName(tester, 'Banco Solar'),
      PixTransferReceiptScreen.checkRecipientAgencyNumber(tester, '2258-4'),
      PixTransferReceiptScreen.checkRecipientAccountNumber(tester, '32542-3'),
      PixTransferReceiptScreen.checkRecipientAccountType(tester, 'Conta Corrente'),
      //check sender
      PixTransferReceiptScreen.checkSenderUserName(tester, 'João Carlos da Silva'),
      PixTransferReceiptScreen.checkSenderDocumentNumber(tester, '929.035.400-39'),
      PixTransferReceiptScreen.checkSenderBankName(tester, 'CrediBank'),
      PixTransferReceiptScreen.checkSenderAgencyNumber(tester, '0124-5'),
      PixTransferReceiptScreen.checkSenderAccountNumber(tester, '12452-6'),
      PixTransferReceiptScreen.checkSenderAccountType(tester, 'Conta Corrente'),
      //check transaction id
      PixTransferReceiptScreen.checkTransactionID(tester, 'E7565486895648s89657978BH'),
    });

    await PixTransferReceiptScreen.dragClose(tester);
    await PixTransferReceiptScreen.tapClose(tester);
  } catch (e) {
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    rethrow;
  }
}
