import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_um/const_keys/pix/pix_keys.dart';
import 'package:prototipo_um/helpers/database/database_helper.dart';
import 'package:prototipo_um/helpers/database/transaction_type.dart';
import 'package:prototipo_um/helpers/database/user.dart';
import 'package:prototipo_um/helpers/database/user_account.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/database/user_transaction.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/ui/pix/pix_keys_page.dart';
import 'package:prototipo_um/ui/pix/pix_transfer_value_page.dart';
import 'package:sqflite/sqflite.dart';

import '../home_page.dart';

class PixPage extends StatefulWidget {
  const PixPage({Key? key, this.user, this.listUserAccount}) : super(key: key);

  final User? user;
  final List<UserAccount>? listUserAccount;

  @override
  _PixPageState createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  @override
  Widget build(BuildContext context) {
    Widget customCardPix(String labelButton, String imageName, Widget page, String key) {
      return SizedBox(
          width: 105,
          height: 105,
          child: Card(
            child: InkWell(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Ink.image(
                    image: AssetImage('images/$imageName'),
                    fit: BoxFit.scaleDown,
                    width: 32.0,
                    height: 32.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 5, top: 15),
                    child: Text(
                      labelButton,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              onTap: () async {

                UserTransaction userTransaction = UserTransaction();
                Database db = await DatabaseHelper().initDb();

                if (page is PixTransferValuePage) {
                  TransactionType? transactionType = await TransactionType().getTransactionType(describeEnum(EnumTransactionType.Pix), db);
                  int idTransactionType = transactionType!.id;
                  userTransaction.idTransactionType = idTransactionType;

                  LayoutCommonFunctions().showModalBottom(
                      PixTransferValuePage(user: widget.user, userTransaction: userTransaction, listUserAccount: widget.listUserAccount), context);

                }else if (page is PixKeysPage){

                  List<UserPixKey> listUserPixKey = await UserPixKey().getAllPixKeyFromUser(widget.user!.id, db);


                  LayoutCommonFunctions().showModalBottom(
                      PixKeysPage(user: widget.user, listUserPixKey: listUserPixKey), context);
                }
              },
              key: Key(key),
            ),
            //shape: CircleBorder(),
          ));
    }

    return Container(
        //padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutCommonFunctions().headModalBottomSheet('Pix', context),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customCardPix('Transferir\ncom Pix', 'transfer.png', PixTransferValuePage(), PixKeys.inkWellPixTransfer),
                        customCardPix('Receber\ncom Pix', 'deposit.png', PixTransferValuePage(), PixKeys.inkWellPixDeposit),
                        customCardPix('Pix Copia\ne Cola', 'copy_paste.png', PixTransferValuePage(), PixKeys.inkWellPixCopyPaste),
                      ],
                    ),
                  ),
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customCardPix('Pagar com\nQR Code', 'qr_code.png', PixTransferValuePage(), PixKeys.inkWellPixQRPayment),
                        customCardPix('Minhas Chaves', 'keys.png', PixKeysPage(), PixKeys.inkWellPixMyKeys),
                        customCardPix('Meus Favoritos', 'favorite.png', PixTransferValuePage(), PixKeys.inkWellPixFavorites),
                      ],
                    ),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Movimentações', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
          )
        ],
      ),
    ));
  }
}
