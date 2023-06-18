import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/recommendation_data.dart';
import 'package:jobsy_app_flutter/widgets/recommend_list.dart';
import 'package:provider/provider.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({Key? key}) : super(key: key);
  static const String id='Recommend_page';
  @override
  State<RecommendPage> createState() => _RecommendPageState();
}




class _RecommendPageState extends State<RecommendPage> {
  final backgroundColor=Color(0xFFF9F5EB);
  final appbarColor= Color(0xFF126180);

  @override
  void initState() {
    super.initState();
    final recommendationProvider = Provider.of<RecommendationData>(context,listen: false);
    recommendationProvider.fetchJobs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
            title:Text('Recommendations'),
            backgroundColor:appbarColor,
        ),
        body:RecommendList()
    );
  }
}
