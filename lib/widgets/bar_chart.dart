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

  @override
  void initState() {
    super.initState();
    jobCountMap=jobsCountByMonth();
  }

  List<_BarData> jobsCountByMonth() {
    final jobProvider = Provider.of<JobData>(context, listen: false);
    List<Job> jobs = [...jobProvider.jobs, ...jobProvider.archiveJobs];
    // Sort the jobs list by created_at
    jobs.sort((a, b) => a.created_at.compareTo(b.created_at));

    DateTime lastMonth = jobs.last.created_at;
    DateTime firstMonth = lastMonth.subtract(Duration(days: 5 * 30)); // Set the range to the last 6 months (approximately)

    List<_BarData> countList = [];

    // Iterate over each month between the first and last month
    for (DateTime date = DateTime(firstMonth.year, firstMonth.month);
    date.isBefore(DateTime(lastMonth.year, lastMonth.month + 1));
    date = DateTime(date.year, date.month + 1)) {
      String monthYear = '${date.month}/${date.year.toString().substring(2)}';
      countList.add(_BarData(monthYear, 0));
    }

    for (var job in jobs) {
      if (job.created_at.isBefore(firstMonth)) {
        continue; // Skip jobs outside the last 6 months range
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
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          color: color,
          width: 6, toY: value,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            borderData: FlBorderData(
              show: true,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Color(0xFF000000).withOpacity(0.2),
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
                  reservedSize: 30,
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
                  reservedSize: 36,
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
                color: Color(0xFF000000).withOpacity(0.2),
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
            maxY: 30,
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
                      fontSize: 22,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 12,
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
    );
  }

}

class _BarData {
  final String monthYear;
  final int count;
  final Color color;

  _BarData(this.monthYear, this.count)
      : color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}


