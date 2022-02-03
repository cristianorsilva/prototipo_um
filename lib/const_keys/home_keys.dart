class HomeKeys {
  // add a private constructor to prevent this class being instantiated
  // e.g. invoke `LocalStorageKey()` accidentally
  HomeKeys._();

  // the properties are static so that we can use them without a class instance
  // e.g. can be retrieved by `LocalStorageKey.saveUserId`.

  static const String iconButtonEye = 'iconButtonEye';
  static const String iconButtonQuestion = 'iconButtonQuestion';
  static const String iconButtonExit = 'iconButtonExit';

  static const String inkWellAccount = 'inkWellAccount';
  static const String inkWellCredit = 'inkWellCredit';

  static const String textWelcomeUserName = 'textWelcomeUserName';
  static const String textAccountBalance = 'textAccountBalance';
  static const String textCreditBalance = 'textCreditBalance';

  static const String inkWellPix = 'inkWellPix';
  static const String inkWellPayment = 'inkWellPayment';
  static const String inkWellTransfer = 'inkWellTransfer';
  static const String inkWellDeposit = 'inkWellDeposit';
  static const String inkWellCellphoneTopUp = 'inkWellCellphoneTopUp';
}
