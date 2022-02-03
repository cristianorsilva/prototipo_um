import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_receipt_keys.dart';
import 'package:prototipo_um/helpers/database/transaction_type.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/utils.dart';

class PixTransferReceiptPage extends StatefulWidget {
  const PixTransferReceiptPage({Key? key, this.userTransaction, this.userFrom, this.userTo, required this.fromAccountPage}) : super(key: key);

  final UserTransaction? userTransaction;
  final User? userFrom;
  final User? userTo;
  final bool fromAccountPage;

  @override
  _PixTransferReceiptPageState createState() => _PixTransferReceiptPageState();
}

class _PixTransferReceiptPageState extends State<PixTransferReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
          key: Key(PixTransferReceiptKeys.singleChildScrowViewMain),
            padding: EdgeInsets.all(15),
            child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                //padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          key: Key(PixTransferReceiptKeys.gestureDetectorClose),
                          child: Icon(
                            Icons.clear_rounded,
                          ),
                          onTap: () {
                            setState(() {
                              widget.fromAccountPage ? Navigator.pop(context) : Navigator.popUntil(context, ModalRoute.withName('/home_page'));
                            });
                          },
                        ),
                        GestureDetector(
                          key: Key(PixTransferReceiptKeys.gestureDetectorShare),
                          child: Icon(
                            Icons.share_rounded,
                          ),
                          onTap: () {
                            setState(() {
                              //TODO: Mostrar tela de share (há exemplo disso no curso?)
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                widget.userTransaction!.isScheduled == 1 ? 'Transferência agendada' : 'Comprovante de transferência',
                key: Key(PixTransferReceiptKeys.textReceiptTitle),
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                Utils().convertDateToBrazilianFormat(DateTime.parse(widget.userTransaction!.dateHour),
                    shownOnlyDate: widget.userTransaction!.isScheduled == 1 ? true : false),
                key: Key(PixTransferReceiptKeys.textTransferDate),
                style: TextStyle(fontSize: 20.0, color: Colors.black54),
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Valor',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    Utils().putCurrencyMask(widget.userTransaction!.value),
                    key: Key(PixTransferReceiptKeys.textTransferValue),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tipo de Transferência',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    describeEnum(EnumTransactionType.values[widget.userTransaction!.idTransactionType]),
                    key: Key(PixTransferReceiptKeys.textTransferType),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                children: [
                  Icon(Icons.payment),
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Text(
                    'Destino',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nome',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userTo!.name,
                    key: Key(PixTransferReceiptKeys.textRecipientFullUserName),
                    style: TextStyle(fontSize: 16, color: Colors.black54,),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                      'CPF',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  Text(
                    widget.userTo!.document,
                    key: Key(PixTransferReceiptKeys.textRecipientDocumentNumber),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ), //'***.458.425-**'
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Instituição',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userTo!.bankName,
                    key: Key(PixTransferReceiptKeys.textRecipientBankName),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agência',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userTo!.agency,
                    key: Key(PixTransferReceiptKeys.textRecipientAgencyNumber),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Conta',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userTo!.account,
                    key: Key(PixTransferReceiptKeys.textRecipientAccountNumber),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tipo de conta',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Conta Corrente',
                    key: Key(PixTransferReceiptKeys.textRecipientAccountType),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                children: [
                  Icon(Icons.payment),
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Text(
                    'Origem',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nome',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userFrom!.name,
                    key: Key(PixTransferReceiptKeys.textSenderFullUserName),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CPF',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userFrom!.document,
                    key: Key(PixTransferReceiptKeys.textSenderDocumentNumber),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Instituição',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userFrom!.bankName,
                    key: Key(PixTransferReceiptKeys.textSenderBankName),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agência',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userFrom!.agency,
                    key: Key(PixTransferReceiptKeys.textSenderAgencyNumber),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Conta',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.userFrom!.account,
                    key: Key(PixTransferReceiptKeys.textSenderAccountNumber),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tipo de conta',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Conta Corrente',
                    key: Key(PixTransferReceiptKeys.textSenderAccountType),
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text('ID da transação:'),
              Text('E7565486895648s89657978BH', key: Key(PixTransferReceiptKeys.textTransactionID),),
            ])));
  }
}
