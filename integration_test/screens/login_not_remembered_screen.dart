import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/login_not_remembered_keys.dart';

import '../test_extensions.dart';

class LoginNotRememberedScreen {
  Finder singleChildScrowViewMain;
  Finder inputDocument;
  Finder inputPassword;
  Finder buttonLogin;
  Finder textForgotPassword;
  Finder textNewUser;
  Finder alertDialogTitle;
  Finder alertDialogMessage;
  Finder alertDialogButtonOk;

  LoginNotRememberedScreen._({
    required this.singleChildScrowViewMain,
    required this.inputDocument,
    required this.inputPassword,
    required this.buttonLogin,
    required this.textForgotPassword,
    required this.textNewUser,
    required this.alertDialogTitle,
    required this.alertDialogMessage,
    required this.alertDialogButtonOk,
  });

  static final LoginNotRememberedScreen _finders = LoginNotRememberedScreen._(
    singleChildScrowViewMain: find.byKey(const Key(LoginNotRememberedKeys.singleChildScrowViewMain)),
    inputDocument: find.byKey(const Key(LoginNotRememberedKeys.inputDocument)),
    inputPassword: find.byKey(const Key(LoginNotRememberedKeys.inputPassword)),
    buttonLogin: find.byKey(const Key(LoginNotRememberedKeys.buttonLogin)),
    textForgotPassword: find.byKey(const Key(LoginNotRememberedKeys.textForgotPassword)),
    textNewUser: find.byKey(const Key(LoginNotRememberedKeys.textNewUser)),
    alertDialogTitle: find.byKey(const Key(LoginNotRememberedKeys.alertDialogTitle)),
    alertDialogMessage: find.byKey(const Key(LoginNotRememberedKeys.alertDialogMessage)),
    alertDialogButtonOk: find.byKey(const Key(LoginNotRememberedKeys.alertDialogButtonOk)),
  );

  static Future<void> informUserAndPassword(WidgetTester tester, String documentID, String password) async {
    //enter the data
    await tester.enterText(LoginNotRememberedScreen._finders.inputDocument, documentID);
    await tester.enterText(LoginNotRememberedScreen._finders.inputPassword, password);
    await simulateKeyUpEvent(LogicalKeyboardKey.escape);


    await tester.pumpAndSettle();
  }

  static Future<void> dragButtonLogin(WidgetTester tester) async {
    await tester.dragUntilVisible(
        LoginNotRememberedScreen._finders.buttonLogin.last, LoginNotRememberedScreen._finders.singleChildScrowViewMain.last, Offset.fromDirection(5.0));
  }

  static Future<void> tapButtonLogin(WidgetTester tester) async {
    //scrolls the screen does not work, so the drag until visible works well
    await tester.dragUntilVisible(
        LoginNotRememberedScreen._finders.buttonLogin, LoginNotRememberedScreen._finders.singleChildScrowViewMain, Offset.fromDirection(5.0));

    //await tester.tap(LoginNotRememberedScreen._finders.buttonLogin);
    await tester.tap(LoginNotRememberedScreen._finders.buttonLogin);

    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }

  //Just for testing
  static String? checkTextForgotPassword(WidgetTester tester, String checkText) {
    try {
      Text text = tester.widget(LoginNotRememberedScreen._finders.textForgotPassword.last) as Text;
      expect(checkText, text.data);
    } on TestFailure catch (testFailure, e) {
      return testFailure.message;
    }
  }

  static void checkTextForgotPassword2(WidgetTester tester, String checkText) {
    Text text = tester.widget(LoginNotRememberedScreen._finders.textForgotPassword.last) as Text;
    expect(text.data, checkText);
  }

  static Function checkTextForgotPassword3(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(LoginNotRememberedScreen._finders.textForgotPassword.last) as Text;
      expect(text.data, checkText);
    };
  }

  static Function checkTextAlertDialogMessage(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(LoginNotRememberedScreen._finders.alertDialogMessage.last) as Text;
      expect(text.data, checkText);
    };
  }


}
