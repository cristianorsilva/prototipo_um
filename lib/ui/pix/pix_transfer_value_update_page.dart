import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/utils.dart';
//import 'package:prototipo_um/ui/model/transfer_pix_model.dart';

class PixTransferValueUpdatePage extends StatefulWidget {
  const PixTransferValueUpdatePage({Key? key, this.userTransaction, this.userPixKey, this.userFrom, this.listUserAccount}) : super(key: key);

  final UserTransaction? userTransaction;
  final UserPixKey? userPixKey;
  final User? userFrom;
  final List<UserAccount>? listUserAccount;

  @override
  _PixTransferValueUpdatePageState createState() => _PixTransferValueUpdatePageState();
}

class _PixTransferValueUpdatePageState extends State<PixTransferValueUpdatePage> {
  final TextEditingController controllerTransferValue = TextEditingController();

  //double _transferValue = 0.0;
  //bool _hasValue = true;

  @override
  void initState() {
    super.initState();
    controllerTransferValue.text = Utils().putCurrencyMask(widget.userTransaction!.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          title: Text('Transferir com Pix'),
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
                    }
                  });
                },
                keyboardType: const TextInputType.numberWithOptions(),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
            height: 70,
            alignment: Alignment.topCenter,
            child: MaterialButton(
              color: widget.userTransaction!.value > 0.0 ? Colors.deepPurple : Colors.grey,
              splashColor: widget.userTransaction!.value > 0.0 ? Colors.white24 : Colors.grey,
              onPressed: () {
                setState(() {
                  if (widget.userTransaction!.value > 0.0) {
                    if (widget.userTransaction!.value > widget.listUserAccount![0].accountBalance) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Automação Fora da Caixa'),
                            content: Text('Você não possui saldo suficiente para essa transferência!'),
                            elevation: 2.0,
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context, widget.userTransaction!.value);
                    }
                  }
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text(
                'Atualizar Valor',
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.only(left: 50, right: 50),
            )));
  }
}
