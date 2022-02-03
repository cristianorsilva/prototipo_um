import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_um/const_keys/pix/pix_transfer_recipient_keys.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/pix_key_type.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';

//import 'package:prototipo_um/ui/model/transfer_pix_model.dart';
import 'package:prototipo_um/ui/pix/pix_verify_data_page.dart';
import 'package:sqflite/sqflite.dart';

class PixTransferRecipientPage extends StatefulWidget {
  const PixTransferRecipientPage({Key? key, this.userTransaction, this.user, this.listUserAccount}) : super(key: key);

  final UserTransaction? userTransaction;

  final User? user;

  final List<UserAccount>? listUserAccount;

  @override
  _PixTransferRecipientPageState createState() => _PixTransferRecipientPageState();
}

class _PixTransferRecipientPageState extends State<PixTransferRecipientPage> {
  bool _hasValue = false;
  String _keyMessage = "";
  TextEditingController _recipientKeyController = TextEditingController();
  EnumPixKeyType _enumPixKeyType = EnumPixKeyType.none;

  UserPixKey? _userPixKey = UserPixKey();

  Widget createChoiceChip(String label, EnumPixKeyType enumPixKeyType, String key) {
    return ChoiceChip(
      key: Key(key),
      label: Text(
        label,
        style: TextStyle(
          color: _enumPixKeyType == enumPixKeyType ? Colors.white : Colors.black,
        ),
      ),
      selectedColor: _enumPixKeyType == enumPixKeyType ? Colors.deepPurple : Colors.grey,
      selected: _enumPixKeyType == enumPixKeyType,
      onSelected: (value) {
        setState(() {
          if (value) {
            //hides keyboard
            FocusScope.of(context).unfocus();
            _recipientKeyController.text = "";
            _hasValue = false;
            switch (enumPixKeyType) {
              case EnumPixKeyType.cpf_cnpj:
                _enumPixKeyType = EnumPixKeyType.cpf_cnpj;
                _keyMessage = 'Informe a chave CPF/CNPJ';
                break;
              case EnumPixKeyType.chave_aleatoria:
                _keyMessage = 'Informe a chave Aleatória';
                _enumPixKeyType = EnumPixKeyType.chave_aleatoria;
                break;
              case EnumPixKeyType.telefone:
                _keyMessage = 'Informe a chave de Telefone';
                _enumPixKeyType = EnumPixKeyType.telefone;
                break;
              case EnumPixKeyType.email:
                _keyMessage = 'Informe a chave de Email';
                _enumPixKeyType = EnumPixKeyType.email;
                break;
              case EnumPixKeyType.none:
                break;
            }
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text('Transferir com Pix'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_hasValue) {
            _userPixKey = await validateKey(context);
            if (_userPixKey != null) {
              //widget.userPixKey!.idTypePixKey = _enumPixKeyType.index;
              //widget.userPixKey!.keyPix = _recipientKeyController.text;
              //widget.userPixKey!.idUser = widget.userTransaction!.idUserFrom;
              //widget.transferPixModel!.pixKeyType = _enumPixKeyType;
              //widget.transferPixModel!.pixKey = _recipientKeyController.text;
              widget.userTransaction!.idUserTo = _userPixKey!.idUser;
              LayoutCommonFunctions().showModalBottom(
                  PixVerifyDataPage(
                      userTransaction: widget.userTransaction,
                      userPixKey: _userPixKey,
                      userFrom: widget.user,
                      listUserAccount: widget.listUserAccount),
                  context);
            }
          }
        },
        child: Icon(Icons.arrow_forward_rounded),
        backgroundColor: _hasValue ? Colors.deepPurple : Colors.grey,
        key: const Key(PixTransferRecipientKeys.buttonArrowContinue),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Para quem você deseja transferir?',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              'O valor a ser transferido é de:',
              style: TextStyle(
                fontSize: 16.0,
              ),
              key: Key(PixTransferRecipientKeys.textValueTransfer),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              //Utils().putCurrencyMask(widget.transferPixModel!.transferValue),
              Utils().putCurrencyMask(widget.userTransaction!.value),
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(bottom: 15)),
            Text(
              'Selecione o tipo de chave do destinatário:',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  createChoiceChip('CPF/CNPJ', EnumPixKeyType.cpf_cnpj, PixTransferRecipientKeys.choiceChipPixKeyCPFCNPJ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  createChoiceChip('Chave Aleatória', EnumPixKeyType.chave_aleatoria, PixTransferRecipientKeys.choiceChipPixKeyAleatory),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  createChoiceChip('Telefone', EnumPixKeyType.telefone, PixTransferRecipientKeys.choiceChipPixKeyCellphone),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  createChoiceChip('Email', EnumPixKeyType.email, PixTransferRecipientKeys.choiceChipPixKeyEmail),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            TextField(
              key: Key(PixTransferRecipientKeys.inputPixKey),
              controller: _recipientKeyController,
              decoration: InputDecoration(
                labelText: _keyMessage,
                labelStyle: TextStyle(color: Colors.black),
                counterText: "",
                //border: OutlineInputBorder(),
                //prefixText: 'Informe a chave',
              ),
              style: TextStyle(fontSize: 18.0),
              onChanged: (text) {
                setState(() {
                  if (text.isNotEmpty) {
                    _hasValue = true;
                  } else {
                    _hasValue = false;
                  }
                });
              },
              enabled: _enumPixKeyType == EnumPixKeyType.none ? false : true,
              keyboardType: (_enumPixKeyType == EnumPixKeyType.cpf_cnpj || _enumPixKeyType == EnumPixKeyType.telefone)
                  ? TextInputType.numberWithOptions(decimal: false)
                  : TextInputType.text,
              inputFormatters: [Utils().defineMaskforSelectedKey(_enumPixKeyType)],
            )
          ],
        ),
      ),
    );
  }

  Future<UserPixKey?> validateKey(BuildContext context) async {
    String pixKeyValue = _recipientKeyController.text;
    bool isValid = false;
    UserPixKey? userPixKey;
    switch (_enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        isValid = validateCPFCNPJ(pixKeyValue);
        userPixKey = await verifyKey(pixKeyValue);
        if (!isValid) {
          await LayoutCommonFunctions().showAlertDialog('Chave inválida', 'A chave CPF/CNPJ informada é inválida!', context,
              PixTransferRecipientKeys.alertDialogTitle, PixTransferRecipientKeys.alertDialogMessage, PixTransferRecipientKeys.alertDialogButtonOk);
        } else if (userPixKey == null) {
          await LayoutCommonFunctions()
              .showAlertDialog('Chave não existe', 'A chave CPF/CNPJ informada não existe!', context, 'keytitle', 'keymessage', 'keybutton');
        }
        break;
      case EnumPixKeyType.chave_aleatoria:
        break;
      case EnumPixKeyType.telefone:
        break;
      case EnumPixKeyType.email:
        break;
      case EnumPixKeyType.none:
        break;
    }
    return userPixKey;
  }

  bool validateCPFCNPJ(String pixKeyValue) {
    if (CPFValidator.isValid(pixKeyValue) || CNPJValidator.isValid(pixKeyValue)) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserPixKey?> verifyKey(String pixKeyValue) async {
    Database db = await DatabaseHelper().db;
    UserPixKey? userPixKey = await UserPixKey().getUserPixKeyByKey(pixKeyValue, db);
    return userPixKey;
  }
}
