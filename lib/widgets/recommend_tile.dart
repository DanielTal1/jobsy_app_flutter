import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommendation.dart';
import '../models/url_data.dart';

class RecommendTile extends StatelessWidget {
  final Recommendation currentRecommend;
  RecommendTile({required this.currentRecommend});



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 3,),
        Container(
            height: 80.0, // Set the desired height
            child: ListTile(
              title: Text(
                currentRecommend.role,
                maxLines: 2, // Maximum of 2 lines
                overflow: TextOverflow.ellipsis, // Truncate with "..."
              ),
              trailing:currentRecommend.url != "" ?
              Image.asset('images/click.png', fit: BoxFit.cover, height: 30.0, width: 30,)
                  :null,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRecommend.company,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Truncate with "..."
                  ),
                  Text(
                    currentRecommend.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Truncate with "..."
                  ),
                  SizedBox(height: 10,),
                ],
              ),
              leading:  Container(
                  width: 55.0,
                  child: Align(
                      alignment: Alignment.center,child:ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: currentRecommend.company_logo == ""
                        ? Image.asset(
                      'images/company.png',
                      fit: BoxFit.cover,
                      height: 60.0,
                      width: 55,
                    )
                        : Image.network(
                      currentRecommend.company_logo,
                      fit: BoxFit.cover,
                      height: 60.0,
                      width: 55,
                    ),
                  ))),
              onTap: () => currentRecommend.url!=""?UrlData.launchUrlFun(currentRecommend.url,context):null
            )),
        SizedBox(height: 3,),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}


