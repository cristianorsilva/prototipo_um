import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototipo_um/const_keys/home_keys.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';
import 'package:prototipo_um/ui/cellphone_top_up/cellphone_top_up_page.dart';
import 'package:prototipo_um/ui/deposit/deposit_page.dart';
import 'package:prototipo_um/ui/login_remembered_page.dart';
import 'package:prototipo_um/ui/payment/payment_page.dart';
import 'package:prototipo_um/ui/pix/pix_page.dart';
import 'package:prototipo_um/ui/transfer/transfer.dart';
import 'package:sqflite/sqflite.dart';

import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.user, this.listUserAccount}) : super(key: key);

  final User? user;
  final List<UserAccount>? listUserAccount;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hideValues = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Usuário
              Container(
                color: Colors.deepPurple,
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage("images/person.png") as ImageProvider)),
                        ),
                        Row(
                          children: [
                            IconButton(
                              key: Key(HomeKeys.iconButtonEye),
                              onPressed: () {
                                setState(() {
                                  if (_hideValues) {
                                    _hideValues = false;
                                  } else {
                                    _hideValues = true;
                                  }
                                });
                              },
                              icon: Icon(
                                _hideValues ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              key: Key(HomeKeys.iconButtonQuestion),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Automação Fora da Caixa'),
                                      content: Text('Bem vindo!'),
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
                              },
                              icon: Icon(
                                Icons.question_answer_rounded,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              key: Key(HomeKeys.iconButtonExit),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginRememberedPage(),
                                    ));
                              },
                              icon: Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Olá, ${widget.user!.name.split(" ").first}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            key: ValueKey(HomeKeys.textWelcomeUserName))
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              //Conta
              InkWell(
                key: Key(HomeKeys.inkWellAccount),
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
                              Icon(Icons.account_balance),
                              Padding(padding: EdgeInsets.only(left: 10.0)),
                              Text('Conta',
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
                      Text(_hideValues ? 'R\$ ---,--' : '${Utils().putCurrencyMask(widget.listUserAccount![0].accountBalance)}',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          key: Key(HomeKeys.textAccountBalance))
                    ],
                  ),
                ),
                onTap: () async {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AccountPage(
                                  user: widget.user,
                                  listUserAccount: widget.listUserAccount,
                                )));
                  });
                },
              ),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              //Cartão
              InkWell(
                key: Key(HomeKeys.inkWellCredit),
                onTap: () {},
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
                              Icon(Icons.credit_card),
                              Padding(padding: EdgeInsets.only(left: 10.0)),
                              Text('Cartão', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text('Fatura atual',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 5.0)),
                      Text(_hideValues ? 'R\$ ---,--' : 'R\$ 345,50',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          key: Key(HomeKeys.textCreditBalance)),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              //Modos de pagamento
              Container(
                height: 125.0,
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      LayoutCommonFunctions().circularButtonHomePage(
                          'Pix', PixPage(user: widget.user, listUserAccount: widget.listUserAccount), 'pix_logo.png', context, HomeKeys.inkWellPix),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      LayoutCommonFunctions().circularButtonHomePage('Pagar', PaymentPage(), 'payment.png', context, HomeKeys.inkWellPayment),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      LayoutCommonFunctions().circularButtonHomePage('Transferir', Transfer(), 'transfer.png', context, HomeKeys.inkWellTransfer),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      LayoutCommonFunctions().circularButtonHomePage('Depositar', DepositPage(), 'deposit.png', context, HomeKeys.inkWellDeposit),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      LayoutCommonFunctions().circularButtonHomePage(
                          'Recarga \n de celular', CellPhoneTopUpPage(), 'cellphone_top_up.png', context, HomeKeys.inkWellCellphoneTopUp),
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
}
