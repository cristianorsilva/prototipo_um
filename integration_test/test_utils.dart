import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'tests/login_test.dart';

class TestUtils {
  static Future<void> takeScreenshot(
      WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String dirFeature, String dirDateHour, String dirTestName) async {
    DateFormat formatter = DateFormat('HH:mm:ss:SSSS');
    String screenshotName = formatter.format(DateTime.now()).replaceAll(":", "_");

    //print('A plataforma é android? ${Platform.isAndroid}');
    /*
    if (kIsWeb) {
      await binding.takeScreenshot('$dirFeature$dirDateHour$dirTestName$screenshotName');
      return;
    } else if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
    }

     */
    await tester.pumpAndSettle();
    await binding.takeScreenshot('$dirFeature$dirDateHour$dirTestName$screenshotName');
  }
}
