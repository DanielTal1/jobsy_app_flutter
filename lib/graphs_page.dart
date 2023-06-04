import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/bar_chart.dart';
import 'package:jobsy_app_flutter/widgets/pie_chart.dart';

class MyChartPage extends StatefulWidget {
  static const String id = 'MyChartPage';
  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  bool isPie=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
        backgroundColor: const Color(0xFF126180),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 100, // Adjust the width as needed
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isPie = true;
                    });
                  },
                  icon: Text("Stage",style: TextStyle(fontSize: 16),),
                ),
              ),
              Container(
                width: 100, // Adjust the width as needed
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isPie = false;
                    });
                  },
                  icon: Text("Month",style: TextStyle(fontSize: 16),),
                ),
              ),
            ],
          ),
        ),
      ),
        body: Center(
        child: isPie?PieChartPage():BarChartByMonth(),
      ),
    );
  }
}
