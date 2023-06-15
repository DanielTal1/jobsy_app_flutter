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

  @override
  Widget build(BuildContext context) {
    final recommendProvider = Provider.of<RecommendationData>(context);
    final recommendations_list = recommendProvider.recommendations;

    return recommendProvider.isLoading ? Center(child: CircularProgressIndicator()) :
    ListView.builder(itemBuilder: (context, index) {
      return RecommendTile(
          currentRecommend: recommendations_list[index]
      );
    },
        itemCount: recommendations_list.length
    );
  }

}

