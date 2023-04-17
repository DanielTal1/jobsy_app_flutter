import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/home_page.dart';
import 'package:jobsy_app_flutter/welcome_screen.dart';
import 'package:jobsy_app_flutter/login.dart';
import 'package:jobsy_app_flutter/sign_up_page.dart';
import 'package:provider/provider.dart';

import 'models/Job_data.dart';


void main() => runApp(Jobsy());

class Jobsy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>JobData(),
      child:MaterialApp(
      initialRoute:HomePage.id,
      routes:{
        HomePage.id:(context)=>HomePage(),
         WelcomeScreen.id:(context)=>WelcomeScreen(),
         Login.id:(context)=> Login(),
         SignUpPage.id:(context)=>SignUpPage(),
      },
    )
    );
  }
}