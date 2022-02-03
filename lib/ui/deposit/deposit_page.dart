import 'package:flutter/material.dart';

import '/helpers/layout_common_functions.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutCommonFunctions().headModalBottomSheet('Depositar', context),
              Padding(padding: EdgeInsets.only(bottom: 10)),

            ],
          ),
        ));
  }
}
