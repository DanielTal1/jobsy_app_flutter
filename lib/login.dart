import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/username_data.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const String id='Login';
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String loginError="";
  final appbarColor=Color(0xFF126180);
  final normalPad=20.0;
  final smallPad=10.0;
  final bigPad=30.0;
  final veryBigPad=40.0;
  final jobsyImageHeight=70.0;
  final buttonCircularRadius=30.0;
  final buttonWidth=200.0;
  final buttonHeight=42.0;
  final buttonContainerHeight=50.0;
  final buttonColor=Color(0xFF0093AF);
  final buttonElevation=5.0;


  Future<bool> checkLogin() async {
    String? token=await UsernameData.getToken();
    if(token==null){
      token="";
    }
    http.Response response=await http.post(
      Uri.parse('http://10.0.2.2:3000/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
        'token':token
      }),
    );
    var message= jsonDecode(response.body)['message'];
    if(message=="logged in successfully"){
      return true;
    }
    return false;
  }




  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
      appBar: AppBar(
          backgroundColor:appbarColor,
          title: const Text('Jobsy')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: normalPad, right: normalPad),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero( //hero animation
                    tag: 'logo',
                    child:Container(
                      child: Image.asset('images/Jobsy.png'),
                      height: jobsyImageHeight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: normalPad),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: normalPad),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height:veryBigPad),
              Text(loginError),
              Container(
                height: buttonContainerHeight,
                width: double.infinity,
                // height: double.infinity,
                padding: EdgeInsets.only(left: smallPad, right: smallPad),
                child: Material(
                  elevation: buttonElevation,
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(buttonCircularRadius),
                  child: MaterialButton(
                    onPressed: () async {
                      loginError="";
                      if (_formKey.currentState!.validate()) {
                        if(await checkLogin()){
                          await UsernameData.saveUsername(_usernameController.text);//save username
                          await FirebaseMessaging.instance.subscribeToTopic('notifications'); //subscribe  the current device to firebase
                          _usernameController.clear();
                          _passwordController.clear();
                          Navigator.pushNamed(context, HomePage.id); //move to homePage
                        }
                        else{
                          setState(() {
                            loginError="Invalid username or password"; //change error
                          });
                        }
                      }
                    },
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
