import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
          backgroundColor:const Color(0xFF72A0C1),
          title: const Text('Jobsy')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child:Container(
                      child: Image.asset('images/Jobsy.png'),
                      height: 70.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
              SizedBox(height: 40.0),
              Text(loginError),
              Container(
                height: 50,
                width: double.infinity,
                // height: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Material(
                  elevation: 5.0,
                  color: Color(0xFF0093AF),
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () async {
                      loginError="";
                      if (_formKey.currentState!.validate()) {
                        if(await checkLogin()){
                          await UsernameData.saveUsername(_usernameController.text);
                          await FirebaseMessaging.instance.subscribeToTopic('notifications');
                          Navigator.pushNamed(context, HomePage.id);
                        }
                        else{
                          setState(() {
                            loginError="Invalid username or password";
                          });
                        }
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
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
