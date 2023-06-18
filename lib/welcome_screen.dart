import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/sign_up_page.dart';
import 'login.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final appBarColor= Color(0xFF72A0C1);
  final bodyPadding=24.0;
  final iconImageSize=200.0;
  final smallPad=10.0;
  final bigPad=30.0;
  final buttonPad=16.0;
  final fontSize=15.0;
  final firstButtonColor=Color(0xFF0093AF);
  final secondButtonColor=Color(0xFF0077c0);
  final buttonWidth=200.0;
  final buttonHeight=42.0;
  final buttonElevation=5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:appBarColor,
          title: const Text('Jobsy')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: bodyPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(//hero animation
                  tag: 'logo',
                  child:Container(
                      child: Image.asset('images/Jobsy.png'),
                      height:iconImageSize,
                    ),
                ),
                SizedBox(
                  height: smallPad,
                ),
                Text(
                  'Please download the compatible google extension!',
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)
                )
              ],
            ),
            SizedBox(
              height:bigPad,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: buttonPad),
              child: Material(
                elevation: buttonElevation,
                color:firstButtonColor,
                borderRadius: BorderRadius.circular(bigPad),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Login.id);
                  },
                  minWidth: buttonWidth,
                  height: buttonHeight,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: buttonPad),
              child: Material(
                color: secondButtonColor,
                borderRadius: BorderRadius.circular(bigPad),
                elevation: buttonElevation,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpPage.id);
                  },
                  minWidth: buttonWidth,
                  height:buttonHeight,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}