import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototipo_um/helpers/database/pix_key_type.dart';
import 'package:prototipo_um/helpers/database/user_pix_key.dart';
import 'package:prototipo_um/helpers/layout_common_functions.dart';
import 'package:prototipo_um/helpers/utils.dart';

class PixTokenPage extends StatefulWidget {
  const PixTokenPage({Key? key, this.userPixKey, this.enumPixKeyType}) : super(key: key);

  final UserPixKey? userPixKey;
  final EnumPixKeyType? enumPixKeyType;

  @override
  _PixTokenPageState createState() => _PixTokenPageState();
}

class _PixTokenPageState extends State<PixTokenPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      startTimer();
    });
  }

  TextEditingController _textTokenController = TextEditingController();
  bool _loadingIsVisible = false;
  bool _isCountdownVisible = true;
  late Timer _timer;
  int _start = 50;

  //bool _isTextTokenEnabled = true;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 50;
            _isCountdownVisible = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //Text(definePixKeyOnPage(widget.enumPixKeyType!), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                Text('Insira o código enviado para ' + widget.userPixKey!.keyPix, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.only(top: 50.0)),

                TextField(
                  controller: _textTokenController,
                  decoration: InputDecoration(
                    hintText: '000000',
                    enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                    floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                    hintStyle: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  //enabled: _isTextTokenEnabled,
                  onChanged: (token) async {
                    if (token.length == 6) {
                      setState(() {
                        _loadingIsVisible = true;
                      });
                      int timeDelayed = 2 + Random().nextInt(3);
                      await Future.delayed(Duration(seconds: timeDelayed));

                      if (token == '123456') {

                        //TODO: acessa o banco e salva a nova chave
                        //fecha a tela e volta pra tela principal de Pix
                        //mostra toast de chave inserida com sucesso.



                      } else {
                        setState(() {
                          _loadingIsVisible = false;
                        });
                        await LayoutCommonFunctions().showAlertDialog('Token inválido', 'Token informado é inválido!', context, 'titlekey', 'messagekey', 'buttonkey');
                      }
                    }
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 30)),

                Visibility(
                  visible: !_isCountdownVisible,
                  child: Row(
                    children: [
                      InkWell(
                        child: Text('Solicitar novo código',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        onTap: () {
                          if (_start == 50) {
                            startTimer();
                            _isCountdownVisible = true;
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Icon(
                        Icons.arrow_forward_rounded,
                      )
                    ],
                  ),
                ),

                Visibility(visible: _isCountdownVisible, child: Text('Voce pode solicitar um novo código em $_start segundos'))
              ]))),
          LayoutCommonFunctions().showShadowLoadingAnimation(_loadingIsVisible, context),
          LayoutCommonFunctions().showLoadingAnimation(_loadingIsVisible, context),
        ]));
  }
}

//TODO: cadastrar a chave de email ou telefone e retornar toast, exibir loading.....
