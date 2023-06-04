import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../models/Job_data.dart';
import '../models/job.dart';
import '../models/stage.dart';
import '../models/stage_data.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  int touchedIndex = -1;

  List<PieChartSectionData> getSections() {
    final JobProvider = Provider.of<JobData>(context, listen: false);
    List<Job> allJobs = [...JobProvider.jobs, ...JobProvider.archiveJobs];
    List<StageData> chartData = StageData.prepareChartData(allJobs);

    int totalCount = 0;
    for (final stageData in chartData) {
      totalCount += stageData.count;
    }

    return List.generate(chartData.length, (i) {
      final stageData = chartData[i];
      final bool isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20.0 : 16.0;
      final double radius = isTouched ? 110.0 : 100.0;
      final double widgetSize = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      int count = stageData.count;
      if (count > 0) {
        double percentage = count / totalCount;
        double value = percentage * 100;

        Color sectionColor = Colors.primaries[i % Colors.primaries.length];

        return PieChartSectionData(
          color: sectionColor,
          value: value,
          title: count.toString(),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          badgeWidget: Container(
            width: widgetSize,
            height: widgetSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: sectionColor, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                stageData.iconPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          badgePositionPercentageOffset: 0.98,
        );
      }

      return PieChartSectionData(
        color: Colors.transparent,
        value: 0.0,
        radius: 0.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 30), // Adjust the top padding as needed
          child: Text(
            "The Jobs Stages",
            style: TextStyle(fontSize: 25),
          ),
        ),
        AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sections: getSections(),
            centerSpaceRadius: 40,
            sectionsSpace: 0,
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                setState(() {
                  if (response != null) {
                    touchedIndex = response.touchedSection?.touchedSectionIndex ?? -1;
                  } else {
                    touchedIndex = -1;
                  }
                });
              },
            ),
          ),
        ),
      ),
    ])
    );
  }
}
