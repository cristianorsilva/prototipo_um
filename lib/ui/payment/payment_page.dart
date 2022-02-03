import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/ui/home_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutCommonFunctions().headModalBottomSheet('Pagar', context),
              Padding(padding: EdgeInsets.only(bottom: 10)),

            ],
          ),
        ));
  }
}
