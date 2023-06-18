import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recommendation.dart';
import '../models/url_data.dart';

class RecommendTile extends StatelessWidget {
  final Recommendation currentRecommend;
  RecommendTile({required this.currentRecommend});
  final verySmallPad=3.0;
  final dividerHeight=2.0;
  final roleMaxLines=2;
  final companyAndLocationMaxLines=1;
  final containerHeight=80.0;
  final smallPad=10.0;
  final trialingWidth=130.0;
  final iconWidth=55.0;
  final iconHeight=60.0;
  final clickIconSize=30.0;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: verySmallPad,),
        Container(
            height: containerHeight,
            child: ListTile(
              title: Text(
                currentRecommend.role,
                maxLines: roleMaxLines, // Maximum of 2 lines
                overflow: TextOverflow.ellipsis, // Truncate with "..."
              ),
              trailing:currentRecommend.url != "" ?
              Image.asset('images/click.png', fit: BoxFit.cover, height: clickIconSize, width: clickIconSize,)
                  :null,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRecommend.company,
                    maxLines: companyAndLocationMaxLines,
                    overflow: TextOverflow.ellipsis, // Truncate with "..."
                  ),
                  Text(
                    currentRecommend.location,
                    maxLines: companyAndLocationMaxLines,
                    overflow: TextOverflow.ellipsis, // Truncate with "..."
                  ),
                  SizedBox(height: smallPad,),
                ],
              ),
              leading:  Container(
                  width: iconWidth,
                  child: Align(
                      alignment: Alignment.center,child:ClipRRect(
                    borderRadius: BorderRadius.circular(smallPad),
                    child: currentRecommend.company_logo == ""
                        ? Image.asset(
                      'images/company.png',
                      fit: BoxFit.cover,
                      height:iconHeight,
                      width: iconWidth,
                    )
                        : Image.network(
                      currentRecommend.company_logo,
                      fit: BoxFit.cover,
                      height: iconHeight,
                      width: iconWidth,
                    ),
                  ))),
              onTap: () => currentRecommend.url!=""?UrlData.launchUrlFun(currentRecommend.url,context):null
            )),
        SizedBox(height: verySmallPad,),
        Divider(
          height: dividerHeight,
          color: Colors.grey,
        ),
      ],
    );
  }
}


