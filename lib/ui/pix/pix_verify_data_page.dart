import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_recipient_keys.dart';
import 'package:prototipo_um/const_keys/pix/pix_verify_data_keys.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/transaction_type.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';
import 'dart:math';

//import 'package:prototipo_um/ui/model/transfer_pix_model.dart';
import 'package:prototipo_um/ui/pix/pix_schedule_page.dart';
import 'package:intl/intl.dart';
import 'package:prototipo_um/ui/pix/pix_transfer_receipt_page.dart';
import 'package:prototipo_um/ui/pix/pix_transfer_value_update_page.dart';
import 'package:sqflite/sqflite.dart';

class PixVerifyDataPage extends StatefulWidget {
  const PixVerifyDataPage({Key? key, this.userTransaction, this.userPixKey, this.userFrom, this.listUserAccount}) : super(key: key);

  final UserTransaction? userTransaction;
  final UserPixKey? userPixKey;
  final User? userFrom;
  final List<UserAccount>? listUserAccount;

  @override
  _PixVerifyDataPageState createState() => _PixVerifyDataPageState();
}

class _PixVerifyDataPageState extends State<PixVerifyDataPage> {
  //bool _hasValue = false;
  String _paymentDate = "Agora";
  User? _userTo = User();
  GlobalKey _keyMainColumn = GlobalKey();
  bool _loadingIsVisible = false;

  Future<void> populateUserTo() async {
    Database db = await DatabaseHelper().initDb();
    _userTo = await User().getUser(widget.userTransaction!.idUserTo, db);
    setState(() {});
  }

  Future<void> executeTransaction() async {
    Database db = await DatabaseHelper().initDb();
    List<UserAccount> listUserAccountTo = await UserAccount().getAllUserAccountsFromUser(_userTo!.id, db);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (widget.userTransaction!.dateHour.substring(0, 10) == formatter.format(DateTime.now())) {
      //new accountBalance for UserFrom
      widget.listUserAccount![0].accountBalance =
          num.parse((widget.listUserAccount![0].accountBalance - widget.userTransaction!.value).toStringAsFixed(2));
      //new accountBalance for UserTo
      listUserAccountTo[0].accountBalance = num.parse((listUserAccountTo[0].accountBalance + widget.userTransaction!.value).toStringAsFixed(2));
    }

    await db.transaction((txn) async {
      //add userTransaction in database
      await UserTransaction().saveUserTransactionTXN(widget.userTransaction!, txn);
      //update accountBalance for UserFrom in database
      await UserAccount().updateUserAccountTXN(widget.listUserAccount![0], txn);
      //update accountBalance for UserTo in database
      await UserAccount().updateUserAccountTXN(listUserAccountTo[0], txn);
    });
  }

  @override
  void initState() {
    super.initState();
    populateUserTo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text('Transferir com Pix'),
      ),
      body: SingleChildScrollView(
          key: const Key(PixVerifyDataKeys.singleChildScrowViewMain),
          child: Stack(
        children: [
          Column(key: _keyMainColumn, children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Transferindo',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  GestureDetector(
                    key: Key(PixVerifyDataKeys.gestureDetectorChangeValue),
                    child: Row(
                      children: [
                        Text(
                          Utils().putCurrencyMask(widget.userTransaction!.value),
                          key: Key(PixVerifyDataKeys.textTransferValue),
                          style: TextStyle(fontSize: 32.0, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Icon(
                          Icons.edit,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ),
                    onTap: () {
                      Future value = LayoutCommonFunctions().showModalBottom(
                          PixTransferValueUpdatePage(
                              userTransaction: widget.userTransaction,
                              userPixKey: widget.userPixKey,
                              userFrom: widget.userFrom,
                              listUserAccount: widget.listUserAccount),
                          context);

                      value.then((value) {
                        setState(() {
                          if (value != null) {
                            widget.userTransaction!.value =
                                (double.tryParse(value.toString())! > 0.0 ? double.tryParse(value.toString()) : widget.userTransaction!.value)!;
                          }
                        });
                      });
                    },
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Text(
                    _userTo!.name,
                    key: Key(PixVerifyDataKeys.textRecipientFullUserName),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30)),
                  Divider(
                    height: 0,
                    color: Colors.deepPurpleAccent,
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quando',
                              style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.grey)),
                          Padding(padding: EdgeInsets.only(bottom: 10.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  //TODO: sem a verificação abaixo, a data futura aparece zuada
                                  Text(_paymentDate.length >= 10 ? Utils().convertDateToBrazilianFormat(DateTime.parse(_paymentDate)) : _paymentDate,
                                      key: Key(PixVerifyDataKeys.textTransferDate),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      )),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 12.0)),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Future selectedDate = LayoutCommonFunctions().showModalBottom(
                            PixSchedulePage(userTransaction: widget.userTransaction, userTo: _userTo, listUserAccount: widget.listUserAccount),
                            context);
                        selectedDate.then((value) {
                          DateFormat formatter = DateFormat('dd/MM/yyyy');
                          String selectedDate = formatter.format(value);
                          String actualDate = formatter.format(DateTime.now());
                          setState(() {
                            if (selectedDate == actualDate) {
                              _paymentDate = 'Agora';
                            } else {
                              _paymentDate = value.toString();
                            }
                          });
                        });
                      });
                    },
                  ),
                  Divider(
                    height: 0,
                    color: Colors.deepPurpleAccent,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo de transferência',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey)),
                        Padding(padding: EdgeInsets.only(bottom: 10.0)),
                        Text(describeEnum(EnumTransactionType.values[widget.userTransaction!.idTransactionType]),
                            key: Key(PixVerifyDataKeys.textTransferType),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            )),
                        Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.deepPurpleAccent,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(CPFValidator.isValid(_userTo!.document) ? 'CPF' : 'CNPJ', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      Text(
                          (_userTo!.document.length > 0)
                              ? _userTo!.document.replaceRange(0, 3, "***").replaceRange(_userTo!.document.length - 2, null, "**")
                              : "",
                          key: Key(PixVerifyDataKeys.textRecipientDocumentNumber),
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Instituição', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      Text(_userTo!.bankName,
                          key: Key(PixVerifyDataKeys.textRecipientBankName),
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Agência', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      Text(_userTo!.agency,
                          key: Key(PixVerifyDataKeys.textRecipientAgencyNumber),
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Conta corrente', style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      Text(_userTo!.account,
                          key: Key(PixVerifyDataKeys.textRecipientAccountNumber),
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15.0)),
                ])),
            Padding(padding: EdgeInsets.only(bottom: 70.0))
          ]),
          LayoutCommonFunctions().showShadowLoadingAnimation(_loadingIsVisible, context),
          LayoutCommonFunctions().showLoadingAnimation(_loadingIsVisible, context),
        ],
      )),
      bottomSheet: Stack(
        children: [
          Container(
              height: 70,
              alignment: Alignment.center,
              child: MaterialButton(
                key: const Key(PixVerifyDataKeys.buttonTransfer),
                color: Colors.deepPurple,
                onPressed: () async {
                  setState(() {
                    _loadingIsVisible = true;
                    if (_paymentDate == 'Agora') {
                      widget.userTransaction!.dateHour = DateTime.now().toString();
                    } else {
                      widget.userTransaction!.isScheduled = 1;
                      widget.userTransaction!.dateHour = _paymentDate;
                    }
                  });
                  await executeTransaction();
                  int timeDelayed = 3 + Random().nextInt(5);
                  await Future.delayed(Duration(seconds: timeDelayed));
                  setState(() {
                    _loadingIsVisible = false;
                  });
                  LayoutCommonFunctions().showModalBottom(
                      PixTransferReceiptPage(
                        userTransaction: widget.userTransaction,
                        userFrom: widget.userFrom,
                        userTo: _userTo,
                        fromAccountPage: false,
                      ),
                      context);
                },
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Text(
                  'Transferir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                padding: const EdgeInsets.only(left: 70, right: 70, top: 10, bottom: 10),
              )),
          LayoutCommonFunctions().showShadowLoadingAnimationByHeight(_loadingIsVisible, context, 70)
        ],
      ),
    );
  }
}
