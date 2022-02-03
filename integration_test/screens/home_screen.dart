import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_um/const_keys/home_keys.dart';

class HomeScreen {
  Finder iconButtonEye;
  Finder iconButtonQuestion;
  Finder iconButtonExit;

  Finder inkWellAccount;
  Finder inkWellCredit;

  Finder textWelcomeUserName;
  Finder textAccountBalance;
  Finder textCreditBalance;

  Finder inkWellPix;
  Finder inkWellPayment;
  Finder inkWellTransfer;
  Finder inkWellDeposit;
  Finder inkWellCellphoneTopUp;

  HomeScreen._({
    required this.iconButtonEye,
    required this.iconButtonQuestion,
    required this.iconButtonExit,
    required this.inkWellAccount,
    required this.inkWellCredit,
    required this.textWelcomeUserName,
    required this.textAccountBalance,
    required this.textCreditBalance,
    required this.inkWellPix,
    required this.inkWellPayment,
    required this.inkWellTransfer,
    required this.inkWellDeposit,
    required this.inkWellCellphoneTopUp,
  });

  static final HomeScreen _finders = HomeScreen._(

    iconButtonEye: find.byKey(const Key(HomeKeys.iconButtonEye)),
    iconButtonQuestion: find.byKey(const Key(HomeKeys.iconButtonQuestion)),
    iconButtonExit: find.byKey(const Key(HomeKeys.iconButtonExit)),
    inkWellAccount: find.byKey(const Key(HomeKeys.inkWellAccount)),
    inkWellCredit: find.byKey(const Key(HomeKeys.inkWellCredit)),
    textWelcomeUserName: find.byKey(const Key(HomeKeys.textWelcomeUserName)),
    textAccountBalance: find.byKey(const Key(HomeKeys.textAccountBalance)),
    textCreditBalance: find.byKey(const Key(HomeKeys.textCreditBalance)),
    inkWellPix: find.byKey(const Key(HomeKeys.inkWellPix)),
    inkWellPayment: find.byKey(const Key(HomeKeys.inkWellPayment)),
    inkWellTransfer: find.byKey(const Key(HomeKeys.inkWellTransfer)),
    inkWellDeposit: find.byKey(const Key(HomeKeys.inkWellDeposit)),
    inkWellCellphoneTopUp: find.byKey(const Key(HomeKeys.inkWellCellphoneTopUp)),
  );

  static Function checkTextWelcomeUser(WidgetTester tester, String checkText) {
    return () {
      Text text = tester.widget(HomeScreen._finders.textWelcomeUserName) as Text;
      expect(text.data, checkText);
    };
  }

  static Future<void> tapPix(WidgetTester tester) async {
    await tester.tap(HomeScreen._finders.inkWellPix);
    //waits for the app load the next screen
    await tester.pumpAndSettle();
  }
}
