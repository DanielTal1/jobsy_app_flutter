import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/job_list.dart';
import 'package:provider/provider.dart';
import 'add_job_screen.dart';
import 'models/Job_data.dart';
import 'search_jobs.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id='Home_page';


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
        backgroundColor: Color(0xFFF9F5EB),
        appBar: AppBar(
          leading: IconButton(onPressed: (){},
              icon:Icon(Icons.menu)),
          title:Text('Jobsy'),
          backgroundColor:const Color(0xFF126180),
          actions: [
            IconButton(onPressed: (){},
                icon:Icon(Icons.more_vert))
          ],
            bottom:PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: showSearch==false? Expanded(
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  IconButton(onPressed: (){
                    setState(() {
                      showSearch = true;
                    });
                  },
                      icon:Icon(Icons.search,  color: Colors.white,
                      )),
                  IconButton(onPressed: (){},
                      icon:Icon(Icons.filter_alt_outlined,  color: Colors.white)),
                  IconButton(onPressed: (){},
                      icon:Icon(Icons.sort,  color: Colors.white)),
                ],),
              ) : SearchJobs((){
                setState(() {
                  showSearch=false;
                });
              })
          )
        ),
          body:showSearch?JobList("Search"):JobList("All"),
            floatingActionButton:FloatingActionButton(
                onPressed: (){
                  showModalBottomSheet(context: context,isScrollControlled: true, builder:(context)=>
                  SingleChildScrollView(
                      child: GestureDetector(
                      child:Padding(
                      padding:EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom
                  ),child: Container(decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        )
                      ),
                      child:AddJobScreen()
                      )
                      )
                      )
                  )
                  );
                },
                child: Icon(Icons.add),
              backgroundColor:  Color(0xFF126180)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat

          );
  }
}


