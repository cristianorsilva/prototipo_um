import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:prototipo_um/main.dart' as app;
import 'package:intl/intl.dart';
import '../screens/home_screen.dart';
import '../screens/login_not_remembered_screen.dart';
import '../test_extensions.dart';
import '../test_utils.dart';

late IntegrationTestWidgetsFlutterBinding binding;
String dirFeature = "Feature Login/";
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

  group('Login Tests:', () {
    testWidgets(
        'TC 001 '
        'GIVEN I open the app '
        'AND I inform valid login and password, '
        'WHEN I tap Login button '
        'THEN I log in the app ',
        successfulLogin);

    testWidgets(
        'TC 002 '
        'GIVEN I open the app '
        'AND I inform valid login '
        'AND I inform wrong password, '
        'WHEN I tap Login button '
        'THEN I see "Usuário ou senha inválidos" message ',
        wrongPasswordInformed);

    testWidgets(
        'TC 003 '
        'GIVEN I open the app '
        'AND I inform inexistent login '
        'AND I inform valid password, '
        'WHEN I tap Login button '
        'THEN I see "Usuário ou senha inválidos" message ',
        nonExistentDocumentInformed);

    testWidgets('Testing new features', testingNewFeatures);
  });
}

Future<void> testingNewFeatures(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "New feature test/";

  //funciona
  tester.checkExpectedTextOnTextWidgets({
    LoginNotRememberedScreen.checkTextForgotPassword3(tester, 'Esqueci a senha!'),
    LoginNotRememberedScreen.checkTextForgotPassword3(tester, 'Esqueci a senha'),
    LoginNotRememberedScreen.checkTextForgotPassword3(tester, 'Esqueci a senha@')
  });

  tester.expectTextOnTextWidget('Esqueci a senha', 'textForgotPassword');

  await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
  await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
}

Future<void> successfulLogin(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "1 - Successful Login/";

  try {
    await LoginNotRememberedScreen.informUserAndPassword(tester, '92903540039', '172839');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.tapButtonLogin(tester);
    //if logged with success, expects to find the welcome message for user
    HomeScreen.checkTextWelcomeUser(tester, 'Olá, João').call();
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
  } catch (e) {
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    rethrow;
  }
}

Future<void> wrongPasswordInformed(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "2 - Invalid Password Informed/";

  try {
    await LoginNotRememberedScreen.informUserAndPassword(tester, '92903540039', '172838');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.tapButtonLogin(tester);

    //expects to find message
    //expect(find.text('Usuário ou senha inválidos'), findsOneWidget);
    //expects to find message
    LoginNotRememberedScreen.checkTextAlertDialogMessage(tester, 'Usuário ou senha inválidos').call();

    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
  } catch (e) {
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    rethrow;
  }
}

Future<void> nonExistentDocumentInformed(WidgetTester tester) async {
  //starts the app
  await app.main();
  //wait for app to be settled
  await tester.pumpAndSettle();
  //define the directory for the test result
  dirTestName = "3 - Non existent Document Informed/";

  try {
    await LoginNotRememberedScreen.informUserAndPassword(tester, '90691216037', '172839');
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    await LoginNotRememberedScreen.tapButtonLogin(tester);

    //expects to find message
    LoginNotRememberedScreen.checkTextAlertDialogMessage(tester, 'Usuário ou senha inválidos').call();

    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
  } catch (e) {
    await TestUtils.takeScreenshot(tester, binding, dirFeature, dirDateHour, dirTestName);
    rethrow;
  }
}
