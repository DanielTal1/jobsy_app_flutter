import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommendation.dart';
import '../models/url_data.dart';

class RecommendTile extends StatelessWidget {
  final Recommendation currentRecommend;
  RecommendTile({required this.currentRecommend});



  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title:Text(currentRecommend.role),
      subtitle: Text(currentRecommend.company+" , "+currentRecommend.location),
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8), // Image border
        child: currentRecommend.company_logo==""?Image.asset('images/company.png',fit: BoxFit.cover,height: 50.0,width:50):Image.network(currentRecommend.company_logo, fit: BoxFit.cover,height: 50.0,width:50),
      ),
      onTap:()=>currentRecommend.url!=""?UrlData.launchUrlFun(currentRecommend.url,context):null
      );
  }
}


