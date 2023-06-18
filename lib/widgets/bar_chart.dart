import 'dart:math' as math;
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import '../models/job.dart';



class BarChartByMonth extends StatefulWidget {
  BarChartByMonth({Key? key}) : super(key: key);



  @override
  State<BarChartByMonth> createState() => _BarChartByMonth();
}

class _BarChartByMonth extends State<BarChartByMonth> {
  List<_BarData> jobCountMap = [];
  int maxCount=0;

  @override
  void initState() {
    super.initState();
    jobCountMap=jobsCountByMonth();
  }

  //counts the jobs per month in the last 6 months
  List<_BarData> jobsCountByMonth() {
    final jobProvider = Provider.of<JobData>(context, listen: false);
    List<Job> jobs = [...jobProvider.jobs, ...jobProvider.archiveJobs];
    // Sort the jobs list by created_at
    jobs.sort((a, b) => a.created_at.compareTo(b.created_at));
    DateTime lastMonth = DateTime.now();//current time
    //the 1th day in the month that was 5 month ago
    DateTime firstMonth = DateTime(lastMonth.year, lastMonth.month - 5, 1, 0, 0);

    List<_BarData> countList = [];

    //iterate over each month between the first and last month
    DateTime date = DateTime(firstMonth.year, firstMonth.month); // Start with the first month

    while (date.isBefore(DateTime(lastMonth.year, lastMonth.month + 1))){
      // Create a string representation of the month and year
      String monthYear = '${date.month}/${date.year.toString().substring(2)}';
      countList.add(_BarData(monthYear, 0)); // Initialize the count to 0
      date = DateTime(date.year, date.month + 1); // Move to the next month
    }

    //for each job assigning it to the correct month
    for (var job in jobs) {
      if (job.created_at.isBefore(firstMonth)) {
        continue; //skip jobs before the last 6 months
      }
      String monthYear = '${job.created_at.month}/${job.created_at.year.toString().substring(2)}';
      int index = countList.indexWhere((data) => data.monthYear == monthYear);
      if (index != -1) {
        countList[index] = _BarData(monthYear, countList[index].count + 1);
      }
    }
    return countList;
  }

  BarChartGroupData generateBarGroup(int x, double value, Color color) {
    final barWidth=6.0;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          color: color,
          width: barWidth, toY: value,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  final bigPad=30.0;
  final font=25.0;
  final normalPad=24.0;
  final reservedSize=30.0;
  final chartFont=22.0;
  final blurRadius=12.0;
  final opacity=0.2;//transparency
  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    int maxCount = jobCountMap.fold(0, (max, data) => math.max(max, data.count));
    double maxY = maxCount < 10 ? 10 : ( maxCount + 5);
    return Column(children:[
      Padding(
        padding: EdgeInsets.only(top: bigPad,bottom: bigPad),
        child: Text(
          "Applied jobs by month",
          style: TextStyle(fontSize: font),
        ),
      ),
        Padding(
      padding:  EdgeInsets.all(normalPad),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            borderData: FlBorderData(
              show: true,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black.withOpacity(opacity),
                ),
              ),
            ),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                drawBehindEverything: true,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: reservedSize,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: reservedSize,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(jobCountMap[index].monthYear
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color:Colors.black.withOpacity(opacity),
                strokeWidth: 1,
              ),
            ),
            barGroups: jobCountMap.asMap().entries.map((e) {
              final index = e.key;
              final data = e.value;
              return generateBarGroup(
                index,
                data.count.toDouble(),
                data.color, // Use your desired color here
              );
            }).toList(),
            maxY: maxY,
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipMargin: 0,
                getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                    ) {
                  return BarTooltipItem(
                    rod.toY.toInt().toString(),
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rod.color,
                      fontSize: chartFont,
                      shadows:  [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: blurRadius,
                        )
                      ],
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.spot != null) {
                  setState(() {
                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                  });
                } else {
                  setState(() {
                    touchedGroupIndex = -1;
                  });
                }
              },
            ),
          ),
        ),
      ),
    )
    ]);
  }

}

class _BarData {
  final String monthYear;
  final int count;
  final Color color;

  _BarData(this.monthYear, this.count)
      : color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}


