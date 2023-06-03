
import 'package:jobsy_app_flutter/models/stage.dart';

import 'job.dart';

class StageData {
  final String stage;
  final int count;
  final String iconPath;

  StageData(this.stage, this.count, this.iconPath);

  static List<StageData> prepareChartData(List<Job> jobs) {
    Map<String, int> stageCounts = {};

    jobs.forEach((job) {
      stageCounts[job.interview_stage] = (stageCounts[job.interview_stage] ?? 0) + 1;
    });

    List<StageData> chartData = [];
    stageCounts.forEach((stage, count) {
      var stageDetails = stagesList.firstWhere((stageData) => stageData['name'] == stage);
      String iconPath = stageDetails['image'];
      chartData.add(StageData(stage, count, iconPath));
    });

    return chartData;
  }
}

