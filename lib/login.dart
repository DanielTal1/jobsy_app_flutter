import 'package:flutter/material.dart';

import 'home_page.dart';


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
                  onSaved: (String? value){

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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, HomePage.id);
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
