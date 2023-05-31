import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/recommend_list.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({Key? key}) : super(key: key);
  static const String id='Recommend_page';
  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
        backgroundColor: Color(0xFFF9F5EB),
        appBar: AppBar(
            leading: IconButton(onPressed: (){},
                icon:Icon(Icons.menu)),
            title:Text('Jobsy'),
            backgroundColor:const Color(0xFF126180),
            actions: [
              IconButton(onPressed: (){},
                  icon:Icon(Icons.more_vert))
            ],
        ),
        body:RecommendList()
    );
  }
}
