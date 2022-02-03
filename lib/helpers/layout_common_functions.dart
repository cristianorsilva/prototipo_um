import 'package:flutter/material.dart';
import 'package:prototipo_um/const_keys/helpers/layout_common_functions_keys.dart';

class LayoutCommonFunctions {
  /*
  utilizado para padronizar o título das telas do tipo ModalBottomSheet
 */
  Widget headModalBottomSheet(String titleModalBottom, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.clear_rounded,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 30)),
          Row(children: [
            Text(
              titleModalBottom,
              style: TextStyle(fontSize: 28.0, color: Colors.white, fontWeight: FontWeight.w500),
            )
          ]),
        ],
      ),
    );
  }

/*
Exibe uma tela do tipo ModalBottomSheet
 */
  Future showModalBottom(Widget page, BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: page,
        );
      },
    );
  }

  /*
  Utilizado para gerar os botões circulares de opções na tela Home
   */
  Widget circularButtonHomePage(String labelButton, Widget page, String imageName, BuildContext context, String key) {
    return Column(
      children: [
        //Padding(padding: EdgeInsets.only(bottom: 5.0)),
        SizedBox(
            width: 60,
            height: 60,
            child: Card(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink.image(
                      image: AssetImage('images/$imageName'),
                      fit: BoxFit.cover,
                      width: 32.0,
                      height: 32.0,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
                onTap: () {
                  showModalBottom(page, context);
                },
                key: Key(key),
              ),
            )),
        Padding(padding: EdgeInsets.only(bottom: 5)),
        Text(
          labelButton,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }


  ///Exibe uma tela cinza translúcida sobre toda a tela
  Visibility showShadowLoadingAnimation(bool isVisible, BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Opacity(
        opacity: 0.4,
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  /*
  Exibe uma tela cinza translúcida em parte da tela
   */
  Visibility showShadowLoadingAnimationByHeight(bool isVisible, BuildContext context, double height) {
    return Visibility(
      visible: isVisible,
      child: Opacity(
        opacity: 0.4,
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: height,
          alignment: Alignment.center,
        ),
      ),
    );
  }


  ///Exibe no centro da tela um Loading.
  Visibility showLoadingAnimation(bool isVisible, BuildContext context) {
    return Visibility(
      key: Key(LayoutCommonFunctionsKeys.visibilityCircularProgressIndicator),
      visible: isVisible,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Colors.amberAccent,
          //backgroundColor: Colors.deepPurple,
          valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
          //valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
          strokeWidth: 5.0,
        ),
      ),
    );
  }

  /*
  Exibe um objeto alertDialog com título, mensagem e botão de OK
   */
  Future<void> showAlertDialog(String title, String message, BuildContext context, String titleKey, String messageKey, String buttonKey) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            key: Key(titleKey),
          ),
          content: Text(
            message,
            key: Key(messageKey),
          ),
          elevation: 2.0,
          actions: [
            TextButton(
                key: Key(buttonKey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK')),
          ],
        );
      },
    );
  }

  Future<void> showOptionDialog(String title, String message, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          elevation: 2.0,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Sim')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Não'))
          ],
        );
      },
    );
  }
}
