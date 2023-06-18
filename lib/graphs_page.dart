import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/bar_chart.dart';
import 'package:jobsy_app_flutter/widgets/pie_chart.dart';

class MyChartPage extends StatefulWidget {
  static const String id = 'MyChartPage';

  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  bool isPie = true;
  final appbarColor = Color(0xFF126180);
  final appbarBottomHeight=40.0;
  final appbarBottomWidth=100.0;
  final underlineWidth=2.0;
  final fontSize=16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
        backgroundColor: appbarColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(appbarBottomHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: appbarBottomWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(//white underline for chosen graph
                      bottom: BorderSide(
                        color: isPie ? Colors.white : Colors.transparent,
                        width: underlineWidth,
                      ),
                    ),
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isPie = true;
                        });
                      },
                      icon: Text(
                        "Stage",
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: !isPie ? Colors.white : Colors.transparent,
                        width: underlineWidth,
                      ),
                    ),
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isPie = false;
                        });
                      },
                      icon: Text(
                        "Month",
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: isPie ? PieChartPage() : BarChartByMonth(),
      ),
    );
  }
}
