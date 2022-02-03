import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';

import '../home_page.dart';

class CellPhoneTopUpPage extends StatefulWidget {
  const CellPhoneTopUpPage({Key? key}) : super(key: key);

  @override
  _CellPhoneTopUpPageState createState() => _CellPhoneTopUpPageState();
}

class _CellPhoneTopUpPageState extends State<CellPhoneTopUpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutCommonFunctions().headModalBottomSheet('Recarga de celular', context),
              Padding(padding: EdgeInsets.only(bottom: 10)),

            ],
          ),
        ));
  }
}
