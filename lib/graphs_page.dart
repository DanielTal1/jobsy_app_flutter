import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/bar_chart.dart';
import 'package:jobsy_app_flutter/widgets/pie_chart.dart';

class MyChartPage extends StatefulWidget {
  static const String id = 'MyChartPage';
  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Sample'),
      ),
      body: Center(
        child: BarChartByMonth(),
      ),
    );
  }
}
