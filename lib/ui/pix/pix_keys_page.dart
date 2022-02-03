import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/pix_key_type.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/ui/pix/pix_insert_new_key_page.dart';
import 'package:sqflite/sqflite.dart';

class PixKeysPage extends StatefulWidget {
  const PixKeysPage({Key? key, this.user, this.listUserPixKey}) : super(key: key);

  final User? user;
  final List<UserPixKey>? listUserPixKey;

  @override
  _PixKeysPageState createState() => _PixKeysPageState();
}

class _PixKeysPageState extends State<PixKeysPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        title: Text('Minhas Chaves'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Visualizar minhas chaves
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.vpn_key_rounded),
                              Padding(padding: EdgeInsets.only(left: 10.0)),
                              Text('Visualizar minhas chaves',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text('Visualize suas chaves cadastradas',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          )),
                    ],
                  ),
                ),
                onTap: () async {
                  setState(() {
                    //Navigator.push(context,MaterialPageRoute(builder: (_) => AccountPage(user: widget.user,listUserAccount: widget.listUserAccount,)));
                  });
                },
              ),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              //Cadastrar uma chave
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                    builder: (context) {
                      return FractionallySizedBox(
                          heightFactor: 0.5,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            Icons.clear_rounded,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    //TODO: se a chave de CPF já está cadastrada, então a opção não deve aparecer ao usuário

                                    Visibility(
                                      visible: userHasCPFCNPJPixKey() == EnumPixKeyType.cpf_cnpj ? true : true,
                                      child: pixKeyOption(EnumPixKeyType.cpf_cnpj),
                                    ),
                                    pixKeyOption(EnumPixKeyType.telefone),
                                    pixKeyOption(EnumPixKeyType.email),
                                    pixKeyOption(EnumPixKeyType.chave_aleatoria),
                                  ],
                                ),
                              )));
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add),
                              Padding(padding: EdgeInsets.only(left: 10.0)),
                              Text('Cadastrar uma chave', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text('Cadastre uma chave nova',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 5.0)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell pixKeyOption(EnumPixKeyType enumPixKeyType) {
    //Navigator.push(context,MaterialPageRoute(builder: (_) => AccountPage(user: widget.user,listUserAccount: widget.listUserAccount,)));

    Icon iconKeyType;
    Text textKeyType;

    switch (enumPixKeyType) {
      case EnumPixKeyType.cpf_cnpj:
        iconKeyType = Icon(Icons.article_rounded);
        textKeyType = Text('CPF');
        break;
      case EnumPixKeyType.chave_aleatoria:
        iconKeyType = Icon(Icons.shield_rounded);
        textKeyType = Text('Chave Aleatória');
        break;
      case EnumPixKeyType.telefone:
        iconKeyType = Icon(Icons.settings_cell_rounded);
        textKeyType = Text('Celular');
        break;
      case EnumPixKeyType.email:
        iconKeyType = Icon(Icons.email_rounded);
        textKeyType = Text('Email');
        break;
      case EnumPixKeyType.none:
        iconKeyType = Icon(Icons.error_rounded);
        textKeyType = Text('ERRO');
    }

    InkWell inkWell = InkWell(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(5)),
          Row(
            children: [iconKeyType, Padding(padding: EdgeInsets.only(left: 10)), textKeyType],
          ),
          Padding(padding: EdgeInsets.all(5)),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PixInsertNewKeyPage(
                      user: widget.user,
                      enumPixKeyType: enumPixKeyType,
                    )));
      },
    );
    return inkWell;
  }

  bool userHasCPFCNPJPixKey() {
    bool hasCNPJCPFPixKey = false;

    for (UserPixKey userPixKey in widget.listUserPixKey!) {
      if (userPixKey.idTypePixKey == EnumPixKeyType.cpf_cnpj.index) {
        hasCNPJCPFPixKey = true;
        break;
      }
    }

    return hasCNPJCPFPixKey;
  }
}
