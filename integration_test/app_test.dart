import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:prototipo_um/main.dart' as app;

import 'screens/login_not_remembered_screen.dart';

//import 'package:permission_handler/permission_handler.dart';

Future<void> checkpermission_accessdownloads() async {
  //var accessDownloadsStatus = await Permission.accessMediaLocation.request();
  //var accessDownloadsStatus = await Permission.storage.request();
  //print('Acesso garantido? ${accessDownloadsStatus.isGranted}');
}

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

Future<void> main() async {
  /*

  final Map<String, String> envVars = Platform.environment;
  print('Variáveis de ambiente: ${envVars.toString()}');
  //final String adbPath = envVars['ANDROID_SDK_ROOT']! + '/platform-tools/adb.exe';
  final String adbPath = 'C:\\Users\\Cristiano\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb.exe';
  await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.prototipo.prototipo_um', 'android.permission.WRITE_EXTERNAL_STORAGE']);
  await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.prototipo.prototipo_um', 'android.permission.WRITE_INTERNAL_STORAGE']);
  await integrationDriver();
*/

  /*
  try {
    await integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
        final File image = await File('screenshots/$screenshotName.png')
            .create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );
  } catch (e) {
    print('Error occured: $e');
  }
  */

  print('Id do device $_getId()');

  group('Login Tests:', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;

    /*
adb shell pm grant com.prototipo.prototipo_um android.permission.WRITE_INTERNAL_STORAGE

flutter drive \
  --driver=integration_test/driver.dart \
  --target=integration_test/location_test.dart \
  -d 1f896456a27927d9
     */

    testWidgets('Successful Login', (tester) async {
      //starts the app
      await app.main();
      //wait for app to be settled
      await tester.pumpAndSettle();

      //var deviceId = await _getId();
      //print(deviceId); //1f896456a27927d9

      //await checkpermission_accessdownloads();
      //await tester.pumpAndSettle();

      //await Permission.camera.request();
      //await tester.pumpAndSettle();

      //final permissao = find.text('PERMITIR').first;
      //await tester.tap(permissao);

      //find the elements on screen (create the 'finders')
      //final documentField = find.byKey(const Key('txt_login_value'));
      //final passwordField = find.byKey(const Key('txt_password_value'));
      //final loginButton = find.byKey(const Key('btn_login'));

      //enter the data and tap the button
     // await tester.enterText(LoginNotRememberedScreen.finders.inputDocument, '92903540039');
     // await tester.enterText(LoginNotRememberedScreen.finders.inputPassword, '172839');

      //scrolls the screen does not work, so the drag until visible works well
     // await tester.dragUntilVisible(
     //     LoginNotRememberedScreen.finders.buttonLogin, LoginNotRememberedScreen.finders.inputPassword, Offset.fromDirection(5.0));

     // await tester.tap(LoginNotRememberedScreen.finders.buttonLogin);

      //waits for the app load the next screen
      await tester.pumpAndSettle();

      final usernameField = find.byKey(const Key('welcome_user'));
      print(usernameField.evaluate().toString());

      //if logged with success, expects to find the welcome message for user
      expect(find.text('Olá, João'), findsOneWidget);

      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      await binding.takeScreenshot('Successful login');

    });

    testWidgets('Invalid user or password', (tester) async {
      //starts the app
      await app.main();

      //wait for app to be settled
      await tester.pumpAndSettle();

      //find the elements on screen (create the 'finders')
      final documentField = find.byKey(const Key('txt_login_value'));
      final passwordField = find.byKey(const Key('txt_password_value'));
      final loginButton = find.byKey(const Key('btn_login'));

      //enter the data and tap the button
      await tester.enterText(documentField, '24594051030');
      await tester.enterText(passwordField, '172839');

      //scrolls the screen does not work, so the drag until visible works well
      await tester.dragUntilVisible(loginButton, passwordField, Offset.fromDirection(5.0));

      await tester.tap(loginButton);

      //waits for the app load the next screen
      await tester.pumpAndSettle();

      final alertMessageField = find.byKey(const Key('alertdialog_message'));

      expect(find.text('Usuário ou senha inválidos'), findsOneWidget);

      //await Utils().takeScreenshot(tester, binding);

      //Directory dir = Directory('/storage/emulated/0/Download');
      //print(dir.path);

      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      await binding.takeScreenshot('Invalid user or password');

      /*
      List<int> screenshotBytes = await binding.takeScreenshot('test-screenshot');
      final File image = await File('${dir.path}/test-screenshot.png').create(recursive: true);
      image.writeAsBytesSync(screenshotBytes);
*/

      //print(usernameField.evaluate().toString());
    });
  });
}
