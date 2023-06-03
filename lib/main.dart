import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/graphs_page.dart';
import 'package:jobsy_app_flutter/home_page.dart';
import 'package:jobsy_app_flutter/recommend_page.dart';
import 'package:jobsy_app_flutter/welcome_screen.dart';
import 'package:jobsy_app_flutter/login.dart';
import 'package:jobsy_app_flutter/sign_up_page.dart';
import 'package:provider/provider.dart';

import 'models/Job_data.dart';
import 'models/comment_data.dart';
import 'models/recommendation_data.dart';


void main() => runApp(Jobsy());

class Jobsy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<JobData>(
            create: (context)=>JobData(),
          ),
          ChangeNotifierProvider<RecommendationData>(
            create: (_) => RecommendationData(),
          ),
          ChangeNotifierProvider<CommentData>(
            create: (_) => CommentData(),
          ),
        ],
        child:MaterialApp(
          initialRoute:HomePage.id,
          routes:{
            HomePage.id:(context)=>HomePage(),
            WelcomeScreen.id:(context)=>WelcomeScreen(),
            Login.id:(context)=> Login(),
            SignUpPage.id:(context)=>SignUpPage(),
            RecommendPage.id:(context)=>RecommendPage(),
            MyChartPage.id:(context)=>MyChartPage(),

          },
        )
    );
  }
}