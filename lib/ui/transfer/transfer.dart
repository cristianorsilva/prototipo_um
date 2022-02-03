import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';

import '../home_page.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutCommonFunctions().headModalBottomSheet('Transferir', context),
              Padding(padding: EdgeInsets.only(bottom: 10)),

            ],
          ),
        ));
  }
}
