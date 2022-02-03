class LoginNotRememberedKeys{
  // add a private constructor to prevent this class being instantiated
  // e.g. invoke `LocalStorageKey()` accidentally
  LoginNotRememberedKeys._();

  // the properties are static so that we can use them without a class instance
  // e.g. can be retrieved by `LocalStorageKey.saveUserId`.
  static const String singleChildScrowViewMain ='singleChildScrowViewMain';
  static const String inputDocument = 'inputDocument';
  static const String inputPassword = 'inputPassword';
  static const String buttonLogin = 'buttonLogin';

  static const String textForgotPassword = 'textForgotPassword';
  static const String textNewUser = 'textNewUser';

  static const String alertDialogTitle = 'alertDialogTitle';
  static const String alertDialogMessage = 'alertDialogMessage';
  static const String alertDialogButtonOk = 'alertDialogButtonOk';


}