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

  @override
  void initState() {
    super.initState();
    final recommendationProvider = Provider.of<RecommendationData>(context,listen: false);
    recommendationProvider.fetchJobs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
        backgroundColor: Color(0xFFF9F5EB),
        appBar: AppBar(
            title:Text('Recommendations'),
            backgroundColor:const Color(0xFF126180),
        ),
        body:RecommendList()
    );
  }
}
