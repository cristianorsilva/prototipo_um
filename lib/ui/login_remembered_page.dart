import 'package:flutter/material.dart';

class LoginRememberedPage extends StatefulWidget {
  const LoginRememberedPage({Key? key}) : super(key: key);

  @override
  _LoginRememberedPageState createState() => _LoginRememberedPageState();
}

class _LoginRememberedPageState extends State<LoginRememberedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 150.0),
        child: Column(
          children: [
            Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("images/person.png") as ImageProvider)),
            ),
            Divider(color: Colors.deepPurple,),
            Text('João Carlos da Silva', style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),),
            Divider(color: Colors.deepPurple,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Agência: 1235-9', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Text('Conta: 144426-5', style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),)
              ],
            ),
            Divider(color: Colors.deepPurple,),
            TextButton(onPressed: () {

            }, child: Text('Entrar'))
          ],
        ),
      ),
    );
  }
}
