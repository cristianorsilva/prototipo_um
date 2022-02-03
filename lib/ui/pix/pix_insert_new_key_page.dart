import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/pix_key_type.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';
import 'package:prototipo_um/ui/pix/pix_token_page.dart';
import 'package:sqflite/sqflite.dart';

class PixInsertNewKeyPage extends StatefulWidget {
  const PixInsertNewKeyPage({Key? key, this.user, required this.enumPixKeyType}) : super(key: key);

  final User? user;
  final EnumPixKeyType enumPixKeyType;

  @override
  _PixInsertNewKeyPageState createState() => _PixInsertNewKeyPageState();
}

class _PixInsertNewKeyPageState extends State<PixInsertNewKeyPage> {
  bool _loadingIsVisible = false;
  TextEditingController _textPixKeyEmailController = TextEditingController();
  TextEditingController _textPixKeyTelefoneController = TextEditingController();

  String definePixKeyNameOnPage(EnumPixKeyType enumPixKeyType) {
    String text = "";

    switch (enumPixKeyType) {
      case EnumPixKeyType.none:
        text = 'Erro!';
        break;
      case EnumPixKeyType.cpf_cnpj:
        text = 'Registrar CPF';
        break;
      case EnumPixKeyType.chave_aleatoria:
        text = 'Registrar Chave aleatória';
        break;
      case EnumPixKeyType.telefone:
        text = 'Registrar Celular';
        break;
      case EnumPixKeyType.email:
        text = 'Registrar Email';
        break;
    }

    return text;
  }

  String definePixKeyDescriptionOnPage(EnumPixKeyType enumPixKeyType) {
    String text = "";

    switch (enumPixKeyType) {
      case EnumPixKeyType.none:
        text = 'Erro!';
        break;
      case EnumPixKeyType.cpf_cnpj:
        text = 'Contatos poderão fazer transferências pelo Pix usando apenas seu CPF';
        break;
      case EnumPixKeyType.chave_aleatoria:
        text = 'Com uma chave aleatória você gera uma chave Pix sem compartilhar seus dados a outras pessoas';
        break;
      case EnumPixKeyType.telefone:
        text = 'Insira o celular que você deseja cadastrar como chave Pix.';
        break;
      case EnumPixKeyType.email:
        text = 'Insira o email que você deseja cadastrar como chave Pix.';
        break;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(definePixKeyNameOnPage(widget.enumPixKeyType), style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  Text(definePixKeyDescriptionOnPage(widget.enumPixKeyType),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black38,
                      )),
                  Padding(padding: EdgeInsets.only(top: 50.0)),
                  Visibility(
                    visible: widget.enumPixKeyType == EnumPixKeyType.cpf_cnpj ? true : false,
                    child: Row(
                      children: [
                        Icon(Icons.vpn_key_rounded),
                        Padding(padding: EdgeInsets.only(left: 15.0)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CPF', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Text(widget.user!.document,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black38,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.enumPixKeyType == EnumPixKeyType.chave_aleatoria ? true : false,
                    child: Row(
                      children: [
                        Icon(Icons.shield_rounded),
                        Padding(padding: EdgeInsets.only(left: 15.0)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chave aleatória', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: widget.enumPixKeyType == EnumPixKeyType.email ? true : false,
                      child: TextField(
                        controller: _textPixKeyEmailController,
                        decoration: InputDecoration(
                          labelText: 'Digite o email desejado',
                          hintText: 'Email',
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                          floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                          hintStyle: TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                        inputFormatters: [Utils().defineMaskforSelectedKey(EnumPixKeyType.email)],
                      )),
                  Visibility(
                      visible: widget.enumPixKeyType == EnumPixKeyType.telefone ? true : false,
                      child: TextField(
                          controller: _textPixKeyTelefoneController,
                          decoration: InputDecoration(
                            labelText: 'Digite o celular desejado',
                            hintText: 'Celular',
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                            floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                            hintStyle: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                          inputFormatters: [Utils().defineMaskforSelectedKey(EnumPixKeyType.telefone)],
                          keyboardType: TextInputType.numberWithOptions(decimal: false))),
                ],
              ),
            ),
          ),
          LayoutCommonFunctions().showShadowLoadingAnimation(_loadingIsVisible, context),
          LayoutCommonFunctions().showLoadingAnimation(_loadingIsVisible, context),
        ]),
        bottomSheet:
            //TODO: Visibility abaixo é visível somente para CPF/CNPJ ou Chave aleatória.
            Visibility(
          visible: (widget.enumPixKeyType == EnumPixKeyType.cpf_cnpj)
              ? true
              : (widget.enumPixKeyType == EnumPixKeyType.chave_aleatoria)
                  ? true
                  : false,
          child: Stack(
            children: [
              Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                          child: Column(children: [
                        Text('Quem usa Pix vai saber que você tem uma chave cadastrada por telefone ou e-mail, mas não terá acesso aos seus dados',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 18.0,
                            )),
                        Text('Quem te pagar por Pix poderá ver seu nome completo e alguns dígitos do seu CPF.',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 18.0,
                            )),
                        Padding(padding: EdgeInsets.only(top: 25.0)),
                        MaterialButton(
                          color: Colors.deepPurple,
                          onPressed: () async {
                            setState(() {
                              _loadingIsVisible = true;
                            });
                            bool pixKeyCreated = false;

                            Database db = await DatabaseHelper().initDb();
                            UserPixKey userPixKey = UserPixKey();

                            switch (widget.enumPixKeyType) {
                              case EnumPixKeyType.cpf_cnpj:
                                List<PixKeyType> listTypePixKey = await PixKeyType().getAllPixKeysType(db);
                                userPixKey.idTypePixKey =
                                    listTypePixKey.where((typePixKey) => typePixKey.pixKeyType == describeEnum(EnumPixKeyType.cpf_cnpj)).first.id;
                                userPixKey.idUser = widget.user!.id;
                                userPixKey.keyPix = widget.user!.document;

                                userPixKey = await UserPixKey().insertNewUserPixKey(userPixKey, db);
                                if (userPixKey.id > 0) {
                                  pixKeyCreated = true;
                                }

                                break;
                              case EnumPixKeyType.chave_aleatoria:
                                String aleatoryKey = Utils().generateAleatoryKeyPix();

                                List<PixKeyType> listTypePixKey = await PixKeyType().getAllPixKeysType(db);
                                userPixKey.idTypePixKey =
                                    listTypePixKey.where((typePixKey) => typePixKey.pixKeyType == describeEnum(EnumPixKeyType.chave_aleatoria)).first.id;
                                userPixKey.idUser = widget.user!.id;
                                userPixKey.keyPix = aleatoryKey;

                                userPixKey = await UserPixKey().insertNewUserPixKey(userPixKey, db);
                                if (userPixKey.id > 0) {
                                  pixKeyCreated = true;
                                }
                                break;
                            }
                            int timeDelayed = 3 + Random().nextInt(5);
                            await Future.delayed(Duration(seconds: timeDelayed));

                            setState(() {
                              _loadingIsVisible = false;
                            });

                            if (pixKeyCreated) {
                              print('Chave pix criada: $userPixKey');

                              Navigator.pop(context);
                              Navigator.pop(context);

                              final snack = SnackBar(
                                content: Text(
                                  'Chave pix cadastrada com sucesso',
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                            } else {
                              final snack = SnackBar(
                                content: Text(
                                  'Ocorreu um erro ao cadastrar a chave pix',
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            definePixKeyNameOnPage(widget.enumPixKeyType),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          padding: EdgeInsets.only(left: 70, right: 70, top: 10, bottom: 10),
                        )
                      ])),
                    ],
                  )),
              LayoutCommonFunctions().showShadowLoadingAnimationByHeight(_loadingIsVisible, context, 200)
            ],
          ),
        ),

        //TODO: Visibility abaixo é visível somente para telefone e email
        floatingActionButton: Visibility(
            visible: (widget.enumPixKeyType == EnumPixKeyType.telefone)
                ? true
                : (widget.enumPixKeyType == EnumPixKeyType.email)
                    ? true
                    : false,
            child: FloatingActionButton(
              child: Icon(Icons.navigate_next_rounded),
              onPressed: () async {
                bool isValid = false;
                UserPixKey? userPixKey = null;

                switch (widget.enumPixKeyType) {
                  case EnumPixKeyType.telefone:
                    isValid = await verifyIfEmailCelularKeyIsValid(context, EnumPixKeyType.telefone);
                    if (isValid) {
                      userPixKey = await verifyIfEmailCelularKeyExists(context, EnumPixKeyType.telefone);
                    }

                    break;
                  case EnumPixKeyType.email:
                    isValid = await verifyIfEmailCelularKeyIsValid(context, EnumPixKeyType.email);
                    if (isValid) {
                      userPixKey = await verifyIfEmailCelularKeyExists(context, EnumPixKeyType.email);
                    }
                    break;
                }
                if (userPixKey== null && isValid) {
                  userPixKey = UserPixKey();

                  switch (widget.enumPixKeyType) {
                    case EnumPixKeyType.telefone:
                      userPixKey.keyPix = _textPixKeyTelefoneController.text;
                      userPixKey.idTypePixKey = EnumPixKeyType.telefone.index;
                      break;
                    case EnumPixKeyType.email:
                      userPixKey.keyPix = _textPixKeyEmailController.text;
                      userPixKey.idTypePixKey = EnumPixKeyType.email.index;
                      break;
                  }

                  userPixKey.idUser = widget.user!.id;


                  Navigator.push(context,MaterialPageRoute(builder: (context) => PixTokenPage(userPixKey: userPixKey, enumPixKeyType: widget.enumPixKeyType)));

                }else if(userPixKey != null){
                  //TODO: a chave já é utilizada.
                }

              },
            )));
  }

  ///Verifica se a chave é válida ou não
  Future<bool> verifyIfEmailCelularKeyIsValid(BuildContext context, EnumPixKeyType enumPixKeyType) async {
    String pixKeyValue = "";
    bool isValid = true;
    switch (enumPixKeyType) {
      case EnumPixKeyType.telefone:
        pixKeyValue = _textPixKeyTelefoneController.text;
        if (pixKeyValue.isEmpty || pixKeyValue.length < 15) {
          await LayoutCommonFunctions().showAlertDialog('Celular inválido', 'Formato de celular é inválido!', context, 'titlekey', 'messagekey', 'buttonkey');
          isValid = false;
        }

        break;
      case EnumPixKeyType.email:
        pixKeyValue = _textPixKeyEmailController.text;

        if (pixKeyValue.isEmpty || pixKeyValue.length < 13) {
          await LayoutCommonFunctions().showAlertDialog('Email inválido', 'Formato de email é inválido!', context, 'titlekey', 'messagekey', 'buttonkey');
          isValid = false;
        }

        break;
    }
    return isValid;
  }

  ///Retorna um objeto UserPixKey se a chave já existe, ou nulo se ela não existe.
  Future<UserPixKey?> verifyIfEmailCelularKeyExists(BuildContext context, EnumPixKeyType enumPixKeyType) async {
    UserPixKey? userPixKey;
    switch (enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        break;
      case EnumPixKeyType.chave_aleatoria:
        break;
      case EnumPixKeyType.telefone:
        String pixKeyValue = _textPixKeyTelefoneController.text;
        userPixKey = await getPixKeyIfExists(pixKeyValue);

        if (pixKeyValue.isEmpty || pixKeyValue.length < 15) {
          await LayoutCommonFunctions().showAlertDialog('Celular inválido', 'Formato de celular é inválido!', context, 'titlekey', 'messagekey', 'buttonkey');
        } else if (userPixKey != null) {
          await LayoutCommonFunctions().showOptionDialog('Chave utilizada por outro usuário!', 'Deseja iniciar portabilidade?', context);
        }

        break;
      case EnumPixKeyType.email:
        String pixKeyValue = _textPixKeyEmailController.text;
        userPixKey = await getPixKeyIfExists(pixKeyValue);

        if (pixKeyValue.isEmpty || pixKeyValue.length < 13) {
          await LayoutCommonFunctions().showAlertDialog('Email inválido', 'Formato de email é inválido!', context, 'titlekey', 'messagekey', 'buttonkey');
        } else if (userPixKey != null) {
          await LayoutCommonFunctions().showOptionDialog('Email utilizado por outro usuário!', 'Deseja iniciar portabilidade?', context);
        }

        break;
      case EnumPixKeyType.none:
        break;
    }
    return userPixKey;
  }

  Future<UserPixKey?> getPixKeyIfExists(String pixKeyValue) async {
    Database db = await DatabaseHelper().db;
    UserPixKey? userPixKey = await UserPixKey().getUserPixKeyByKey(pixKeyValue, db);
    return userPixKey;
  }
}
