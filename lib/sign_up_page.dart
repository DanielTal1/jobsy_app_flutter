import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignUpPage extends StatefulWidget {
  static const String id='sign_up_page';
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String loginError="";
  final appbarColor=const Color(0xFF126180);
  final buttonColor=Color(0xFF0077c0);
  final verBigPad=50.0;
  final bigPad=40.0;
  final normalPad=20.0;
  final smallPad=10.0;
  final elevationButton=5.0;
  final jobsyImageHeight=70.0;
  final borderRadius=30.0;
  final buttonHeight=50.0;


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> checkRegister() async {
    http.Response response=await http.post(
      Uri.parse('http://10.0.2.2:3000/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text
      }),
    );
    var message= jsonDecode(response.body)['message'];
    if(message=="User as been added successfully"){
      return true;
    }
    return false;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor:appbarColor,
        title: Text('Jobsy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(normalPad, verBigPad, normalPad, verBigPad),
          child:Center(child:Form(
          key: _formKey,
            child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
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
              SizedBox(height: normalPad),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: bigPad),
              Text(loginError),
              Container(
                height: buttonHeight,
                width: double.infinity,
                // height: double.infinity,
                padding: EdgeInsets.only(left: smallPad, right: smallPad),
                child: Material(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  elevation:elevationButton,
                  child: MaterialButton(
                    onPressed: () async {
                      loginError="";
                      if (_formKey.currentState!.validate()) {
                        if(await checkRegister()){
                          _usernameController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                          Navigator.pushNamed(context, Login.id);
                        }
                        else{
                          setState(() {
                            loginError="Invalid username or password";
                          });
                        }
                      }
                    },
                    child: Text(
                      'Register',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
        ),
    )
    );
  }
}