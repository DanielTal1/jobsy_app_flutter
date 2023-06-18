import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/recommend_tile.dart';
import 'package:provider/provider.dart';
import '../models/recommendation_data.dart';

class RecommendList extends StatefulWidget {
  const RecommendList({Key? key}) : super(key: key);

  @override
  State<RecommendList> createState() => _RecommendListState();
}

class _RecommendListState extends State<RecommendList> {
  final fontSize=20.0;

  @override
  Widget build(BuildContext context) {
    final recommendProvider = Provider.of<RecommendationData>(context);
    final recommendationsList = recommendProvider.recommendations;

    if (recommendationsList.isEmpty) {
      return Center(
        child: Text(
          'Currently there are no recommendations.\nPlease add some jobs and try again.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      );
    }

    if(recommendProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {

      return ListView.builder(
        itemBuilder: (context, index) {
          return RecommendTile(
            currentRecommend: recommendationsList[index],
          );
        },
        itemCount: recommendationsList.length,
      );


    }

  }

}

