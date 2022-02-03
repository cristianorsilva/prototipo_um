import 'package:flutter/material.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';
import 'package:prototipo_um/ui/pix/pix_transfer_receipt_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key, this.user, this.listUserAccount}) : super(key: key);

  final User? user;
  final List<UserAccount>? listUserAccount;

  //final List<UserTransaction>? listUserTransactionFrom;
  //final List<String>? listNameUserToByTransaction;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<UserTransaction> _listUserTransaction = [];
  List<String> _listNameUserToByTransaction = [];

  @override
  void initState() {
    super.initState();
    populateTransactionList();
  }

  Future<void> populateTransactionList() async {
    Database db = await DatabaseHelper().initDb();
    _listUserTransaction = await UserTransaction().getAllTransactionsFromAndToUser(widget.user!.id, db);
    //_listUserTransaction = _listUserTransaction.reversed.toList();
    orderListByScheduled();
    for (UserTransaction userTransaction in _listUserTransaction) {
      print('Page Minha Conta - User transaction: ${userTransaction.toString()}');
      User? user = await User().getUser(userTransaction.idUserTo, db);
      _listNameUserToByTransaction.add(user!.name);
    }
    ;
    setState(() {});
  }

  void orderListByScheduled() {
    _listUserTransaction.sort((a, b) {
      if ((a.isScheduled == 1) && !(b.isScheduled == 0))
        return -1;
      else if (!(a.isScheduled == 1) && (a.isScheduled == 0))
        return 1;
      else
        return 0;
    });
  }

  Text defineOperationDescription(int index) {
    Text defineText;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    if (widget.user!.id == _listUserTransaction[index].idUserFrom) {
      DateTime dateTimeNow = DateTime.now();
      if (DateTime.parse(formatter.format(DateTime.now())).difference(DateTime.parse(_listUserTransaction[index].dateHour.substring(0, 10))).inDays >= 0) {
        defineText = Text('Transferência enviada', style: TextStyle(fontWeight: FontWeight.bold));
      } else {
        defineText = Text('Transferência agendada', style: TextStyle(fontWeight: FontWeight.bold));
      }
    } else {
      if (DateTime.parse(formatter.format(DateTime.now())).difference(DateTime.parse(_listUserTransaction[index].dateHour.substring(0, 10))).inDays >= 0) {
        defineText = Text('Transferência recebida', style: TextStyle(fontWeight: FontWeight.bold));
      } else {
        defineText = Text('Transferência a ser recebida', style: TextStyle(fontWeight: FontWeight.bold));
      }
    }
    return defineText;
  }

  Icon defineIcon(int index) {
    Icon defineIcon;
    if (widget.user!.id == _listUserTransaction[index].idUserFrom) {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      defineIcon = Icon(Icons.call_made_rounded, color: Colors.black38);
    } else {
      defineIcon = Icon(Icons.call_received_rounded, color: Colors.black38);
    }
    return defineIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Minha Conta'),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            //padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Text('Saldo em Conta Corrente',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      fontSize: 15.0,
                    )),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(Utils().putCurrencyMask(widget.listUserAccount![0].accountBalance),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    )),
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Icon(Icons.savings_rounded),
                      Padding(padding: EdgeInsets.only(left: 15)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo em Conta Poupança', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38)),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text('R\$ 825,69', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ]),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                ),
                Text(
                  'Histórico',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 20, top: 25),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.black38,
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                      isDense: true,
                      hintText: 'Buscar',
                      floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listUserTransaction != null ? _listUserTransaction.length : 0,
                  itemBuilder: (context, index) {
                    return transactionItem(index);
                  },
                ),
              ],
            ))));
  }

  Widget transactionItem(int index) {
    return Column(children: [
      InkWell(
        onTap: () async {
          Database db = await DatabaseHelper().initDb();

          UserTransaction userTransaction = _listUserTransaction[index];
          User? userFrom = await User().getUser(userTransaction.idUserFrom, db);
          User? userTo = await User().getUser(userTransaction.idUserTo, db);

          LayoutCommonFunctions().showModalBottom(
              PixTransferReceiptPage(
                userTransaction: userTransaction,
                userFrom: userFrom,
                userTo: userTo,
                fromAccountPage: true,
              ),
              context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                defineIcon(index),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    defineOperationDescription(index),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Text(
                      _listNameUserToByTransaction.isNotEmpty ? _listNameUserToByTransaction[index] : 'Erro',
                      style: TextStyle(color: Colors.black38),
                    ),
                    Text(Utils().putCurrencyMask(_listUserTransaction[index].value), style: TextStyle(color: Colors.black38)),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                  ],
                ),
              ],
            ),
            Text(Utils().convertDateToBrazilianFormat(DateTime.parse(_listUserTransaction[index].dateHour)), style: TextStyle(color: Colors.black38)),

            //TODO: adicionar gesture detector
            //TODO: não atualizou o isScheduled com o app aberto
          ],
        ),
      ),
      Divider(
        height: 0,
        color: Colors.deepPurpleAccent,
      ),
    ]);
  }
}
