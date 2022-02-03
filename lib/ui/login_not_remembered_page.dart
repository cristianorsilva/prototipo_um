import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:prototipo_um/const_keys/login_not_remembered_keys.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:sqflite/sqflite.dart';

import 'home_page.dart';

class LoginNotRememberedPage extends StatefulWidget {
  const LoginNotRememberedPage({Key? key}) : super(key: key);

  @override
  _LoginNotRememberedPageState createState() => _LoginNotRememberedPageState();
}

class _LoginNotRememberedPageState extends State<LoginNotRememberedPage> {
  TextEditingController CPFCNPJController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          key: Key(LoginNotRememberedKeys.singleChildScrowViewMain),
          child: Form(
        key: _formKey,
        child:
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top),
              child: Center(
                child: Container(width: 200, height: 250, child: Image.asset('images/logo_fora_da_caixa.png')),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  TextInputMask(
                    mask: ['999.999.999-99', '99.999.999/9999-99'],
                    placeholder: ' ',
                    maxPlaceHolders: 1,
                    reverse: true,
                  )
                ],
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                  labelText: 'CPF ou CNPJ',
                  hintText: 'Informe seu CPF ou CNPJ',
                  floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                  hintStyle: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
                controller: CPFCNPJController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo de preenchimento obrigatório";
                  }
                },
                key: const Key(LoginNotRememberedKeys.inputDocument),


              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                      labelText: 'Senha',
                      floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                      hintStyle: TextStyle(color: Colors.deepPurple),
                      hintText: 'Informe sua senha'),
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo de preenchimento obrigatório";
                    }
                  },
                  key: const Key(LoginNotRememberedKeys.inputPassword),
                  keyboardType: TextInputType.numberWithOptions(decimal: false)),
            ),
            MaterialButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: const Text(
                'Esqueci a senha',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                key: Key(LoginNotRememberedKeys.textForgotPassword),
              ),
            ),
            Container(
                height: 70,
                alignment: Alignment.topCenter,
                child: MaterialButton(
                  key: const Key(LoginNotRememberedKeys.buttonLogin),
                  color: Colors.deepPurple,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String login = CPFCNPJController.text;
                      bool validLogin = true;
                      if (login.length < 15) {
                        if (!CPFValidator.isValid(login)) {
                          validLogin = false;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Automação Fora da Caixa', key: const Key(LoginNotRememberedKeys.alertDialogTitle)),
                                content: Text('O CPF informado não é válido!', key: const Key(LoginNotRememberedKeys.alertDialogMessage)),
                                elevation: 2.0,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    key: const Key(LoginNotRememberedKeys.alertDialogButtonOk),)
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        if (!CNPJValidator.isValid(login)) {
                          validLogin = false;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Automação Fora da Caixa', key: const Key(LoginNotRememberedKeys.alertDialogTitle)),
                                content: Text('O CNPJ informado não é válido!', key: const Key(LoginNotRememberedKeys.alertDialogMessage)),
                                elevation: 2.0,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    key: const Key(LoginNotRememberedKeys.alertDialogButtonOk),)
                                ],
                              );
                            },
                          );
                        }
                      }
                      User? user = null;
                      if (validLogin) {
                        Database db = await DatabaseHelper().db;
                        user = await User().getUserByDocumentAndPassword(CPFCNPJController.text, passwordController.text, db);
                        if (user == null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Automação Fora da Caixa', key: const Key(LoginNotRememberedKeys.alertDialogTitle),),
                                content: Text('Usuário ou senha inválidos', key: const Key(LoginNotRememberedKeys.alertDialogMessage),),
                                elevation: 2.0,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                  key: const Key(LoginNotRememberedKeys.alertDialogButtonOk),)
                                ],
                              );
                            },
                          );
                        } else {
                          List<UserAccount> listUserAccount = await UserAccount().getAllUserAccountsFromUser(user.id, db);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(name: '/home_page'), builder: (context) => HomePage(user: user, listUserAccount: listUserAccount)));
                        }
                      }
                    }
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.only(left: 50, right: 50),
                )),
            const Text(
              'Novo usuário? Crie sua conta grátis!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
              key: Key(LoginNotRememberedKeys.textNewUser),
            )
          ],
        ),
      )),
    );
  }
}
