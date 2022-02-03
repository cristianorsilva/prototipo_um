import 'dart:async';
import 'dart:io';
//NOTE: this import below causes Error: Not found: 'dart:ui' import 'dart:ui' as ui;
//import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test_driver_extended.dart';

String mainDirectory = 'C:/Screenshots/';

Future<void> main() async {
  try {
    await integrationDriver(
      onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
        final File image = await File('$mainDirectory$screenshotName.png').create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );

  } catch (e) {
    print('Error occured: $e');
    rethrow;
  }

}
