import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_value_keys.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';
//import 'package:prototipo_um/ui/model/transfer_pix_model.dart';
import 'package:prototipo_um/ui/pix/pix_transfer_recipient_page.dart';

class PixTransferValuePage extends StatefulWidget {
  const PixTransferValuePage({Key? key, this.user, this.userTransaction, this.listUserAccount}) : super(key: key);

  final User? user;
  final UserTransaction? userTransaction;
  final List<UserAccount>? listUserAccount;

  @override
  _PixTransferValuePageState createState() => _PixTransferValuePageState();
}

class _PixTransferValuePageState extends State<PixTransferValuePage> {
  final TextEditingController controllerTransferValue = TextEditingController();
  //bool _hasValue = false;
  //num _transferValue = 0.0;
  //UserTransaction _userTransaction = UserTransaction();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text('Transferir com Pix'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.userTransaction!.value > 0) {
            if (widget.userTransaction!.value > widget.listUserAccount![0].accountBalance) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Automação Fora da Caixa',key: Key(PixTransferValueKeys.alertDialogTitle),),
                    content: Text('Você não possui saldo suficiente para essa transferência!', key: Key(PixTransferValueKeys.alertDialogMessage),),
                    elevation: 2.0,
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                      key: Key(PixTransferValueKeys.alertDialogButtonOk),)
                    ],
                  );
                },
              );
            } else {
              widget.userTransaction!.idUserFrom = widget.user!.id;
              LayoutCommonFunctions().showModalBottom(
                  PixTransferRecipientPage(
                    //transferPixModel: TransferPixModel(transferValue: _transferValue),
                    userTransaction: widget.userTransaction, user: widget.user, listUserAccount: widget.listUserAccount
                  ),
                  context);
            }
          }
        },
        child: Icon(Icons.arrow_forward_rounded),
        backgroundColor: (widget.userTransaction!.value > 0) ? Colors.deepPurple : Colors.grey,
        key: Key(PixTransferValueKeys.buttonArrowContinue),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Qual valor você deseja transferir?',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Seu saldo disponível é    ',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  Utils().putCurrencyMask(widget.listUserAccount![0].accountBalance),
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  key: Key(PixTransferValueKeys.textAvailableBalance),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 15)),
            TextField(
              maxLength: 20,
              controller: controllerTransferValue,
              inputFormatters: [
                TextInputMask(
                  mask: ['R!\$! !9,99', 'R!\$! !9+.999.999.999,99'],
                  placeholder: '0',
                  maxPlaceHolders: 3,
                  reverse: true,
                ),
              ],
              decoration: const InputDecoration(hintText: 'R\$ 0,00', counterText: ""),
              style: TextStyle(fontSize: 25.0),
              onChanged: (text) {
                setState(() {
                  if (text.isNotEmpty) {
                    widget.userTransaction!.value = double.parse(text.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));
                    /*if (_userTransaction.value > 0.0) {
                      _hasValue = true;
                    } else {
                      _hasValue = false;
                    }*/
                  }
                });
              },
              keyboardType: const TextInputType.numberWithOptions(),
              key: Key(PixTransferValueKeys.inputTransferValue),
            ),
          ],
        ),
      ),
    );
  }
}
