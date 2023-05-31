import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommendation.dart';

class RecommendTile extends StatelessWidget {
  final Recommendation currentRecommend;
  RecommendTile({required this.currentRecommend});


  Future<void> _launchUrl(url_string,context) async {
    final Uri url = Uri.parse(url_string);
    if (!await launchUrl(url,mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title:Text(currentRecommend.role),
      subtitle: Text(currentRecommend.company+" , "+currentRecommend.location),
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8), // Image border
        child: currentRecommend.company_logo==""?Image.asset('images/company.png',fit: BoxFit.cover,height: 50.0):Image.network(currentRecommend.company_logo, fit: BoxFit.cover,height: 50.0),
      ),
      onTap:()=>currentRecommend.url!=""?_launchUrl("https://www.mako.co.il/",context):null
      );
  }
}


