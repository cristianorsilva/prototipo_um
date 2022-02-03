import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prototipo_um/helpers/database/user_remember.dart';
import 'package:prototipo_um/ui/home_page.dart';
import 'package:prototipo_um/ui/login_not_remembered_page.dart';
import 'package:prototipo_um/ui/login_remembered_page.dart';
import 'package:sqflite/sqflite.dart';

import 'helpers/database/user.dart';
import 'helpers/database/database_helper.dart';
import 'helpers/database/pix_key_type.dart';
import 'helpers/database/transaction_type.dart';
import 'helpers/database/user_account.dart';
import 'helpers/database/user_pix_key.dart';
import 'helpers/database/user_transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter_driver/driver_extension.dart';

//flutter build apk --debug
//semanticsLabel/key deve ser setado nos widgets que o appium precisa interagir (testar)

bool _userRemember = false;

Future<void> main() async {
  //enableFlutterDriverExtension();
  print('iniciou metodo main');
  WidgetsFlutterBinding.ensureInitialized();

  await initiateDatabase();
  initializeDateFormatting().then((_) => runApp(Fintech()));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: Colors.deepPurple, // navigation bar color
    statusBarColor: Colors.deepPurple,
  ));
}

Future<void> initiateDatabase() async {
  //Initialize database
  Database db = await DatabaseHelper().initDb();
  //print(await db.query("sqlite_master"));

  //get remembered user, if exists
  UserRemember? userRemember = await UserRemember().getUserRemember(db);
  if (userRemember == null || userRemember.remember == 0) {
    _userRemember = false;
  } else {
    _userRemember = true;
  }

  //TODO: criar método na database_helper com o bloco de codigo abaixo e utilizar em transições de tela
  //run the scheduled transactions
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<UserTransaction> listUserTransaction =
      await UserTransaction().getAllScheduledTransactions(db);
  for (UserTransaction userTransaction in listUserTransaction) {
    print('Transaction scheduled: ${userTransaction.toString()}');
    if (DateTime.parse(formatter.format(DateTime.now()))
            .difference(
                DateTime.parse(userTransaction.dateHour.substring(0, 10)))
            .inDays >=
        0) {
      print('diferença de dias: ' +
          (DateTime.parse(formatter.format(DateTime.now())).difference(
                  DateTime.parse(userTransaction.dateHour.substring(0, 10))))
              .inDays
              .toString());

      User? userFrom = await User().getUser(userTransaction.idUserFrom, db);
      User? userTo = await User().getUser(userTransaction.idUserTo, db);

      List<UserAccount> listUserAccountFrom = await UserAccount()
          .getAllUserAccountsFromUser(userTransaction.idUserFrom, db);
      List<UserAccount> listUserAccountTo = await UserAccount()
          .getAllUserAccountsFromUser(userTransaction.idUserTo, db);

      //new accountBalance for UserFrom
      listUserAccountFrom[0].accountBalance = num.parse(
          (listUserAccountFrom[0].accountBalance - userTransaction.value)
              .toStringAsFixed(2));
      //new accountBalance for UserTo
      listUserAccountTo[0].accountBalance = num.parse(
          (listUserAccountTo[0].accountBalance + userTransaction.value)
              .toStringAsFixed(2));

      await db.transaction((txn) async {
        //update accountBalance for UserFrom in database
        await UserAccount().updateUserAccountTXN(listUserAccountFrom[0], txn);
        //update accountBalance for UserTo in database
        await UserAccount().updateUserAccountTXN(listUserAccountTo[0], txn);
        //update the userTransaction register
        userTransaction.isScheduled = 0; //means it is not scheduled anymore
        userTransaction.dateHour = DateTime.now().toString();
        await UserTransaction().updateUserTransactionTXN(userTransaction, txn);
      });
      print('Transaction updated: ${userTransaction.toString()}');
    }
  }

  /*

  //print table
  await TypeTransaction().getAllTypeTransactions(db).then((list) {
    list.forEach((element) {
      print('Type transaction: $element');
    });
  });

  //print table
  await TypePixKey().getAllTypePixKeys(db).then((list) {
    list.forEach((element) {
      print('Type pixKey: $element');
    });
  });

  //print table
  await User().getAllUsers(db).then((list) {
    list.forEach((element) {
      print('User: $element');
    });
  });

  //print table
  await UserPixKey().getAllPixKeyFromUser(1, db).then((list) {
    print('PixKey for user 1');
    list.forEach((element) {
      print('UserPixKey: $element');
    });
  });

  //print table
  await UserPixKey().getAllPixKey(db).then((list) {
    print('All PixKey');
    list.forEach((element) {
      print('UserPixKey: $element');
    });
  });

  //get specific user
  await User().getUserByDocumentAndPassword("050.209.090-17", "172839", db).then((value) => print(value));

  //await DatabaseHelper().close();


   */
}

Future<void> getRememberedUser() async {}

class Fintech extends StatefulWidget {
  const Fintech({Key? key}) : super(key: key);

  @override
  _FintechState createState() => _FintechState();
}

class _FintechState extends State<Fintech> {
  @override
  void initState() {
    super.initState();
    print('iniciou metodo initState');
    //initiateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context).copyWith(
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(color: Colors.deepPurple),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepPurple)),
        //home: HomePage(),
        home: _userRemember ? LoginRememberedPage() : LoginNotRememberedPage());
  }
}
