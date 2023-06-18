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
  final fontTouched=20.0;
  final fontNotTouched=16.0;
  final radiusIsTouched=110.0;
  final radiusNotTouched=100.0;
  final widgetTouched=60.0;
  final widgetNotTouched=50.0;
  final smallBorder=2.0;
  final bigPadding=30.0;
  final defaultFont=25.0;
  final badgePosition=0.98;
  final pieCenterSpaceRadius=40.0;
  final pieSectionsSpace=0.0;



  int touchedIndex = -1;

  List<PieChartSectionData> getSections() {
    //gets the data as a list of StageData object(with count,stage and icon)
    final JobProvider = Provider.of<JobData>(context, listen: false);
    List<Job> allJobs = [...JobProvider.jobs, ...JobProvider.archiveJobs];
    List<StageData> chartData = StageData.prepareChartData(allJobs);
    int totalCount = allJobs.length;
    return List.generate(chartData.length, (i) {
      final stageData = chartData[i];
      final bool isTouched = i == touchedIndex;
      final double fontSize = isTouched ? fontTouched : fontNotTouched;
      final double radius = isTouched ? radiusIsTouched : radiusNotTouched;
      final double widgetSize = isTouched ? widgetTouched : widgetNotTouched;
      final shadows = [Shadow(color: Colors.black, blurRadius: smallBorder)];
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
            color: Colors.white,
            shadows: shadows,
          ),
          badgeWidget: Container(
            width: widgetSize,
            height: widgetSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: sectionColor, width: smallBorder),
            ),
            child: ClipOval(
              child: Image.asset(
                stageData.iconPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          badgePositionPercentageOffset: badgePosition,
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
          padding: EdgeInsets.only(top: bigPadding),
          child: Text(
            "The Jobs Stages",
            style: TextStyle(fontSize: defaultFont),
          ),
        ),
        AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            sections: getSections(),
            centerSpaceRadius: pieCenterSpaceRadius,
            sectionsSpace: pieSectionsSpace,
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
