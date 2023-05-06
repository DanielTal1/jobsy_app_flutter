import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Job_data.dart';
import 'models/job.dart';
import 'models/stage.dart';

class JobPage extends StatefulWidget {
  final Job currentJob;
  JobPage({required this.currentJob});


  @override
  State<JobPage> createState() => _JobPageState(currentJob: currentJob);
}

class _JobPageState extends State<JobPage> {
  final Job currentJob;
  _JobPageState({required this.currentJob});
  late String selected_stage=currentJob.interview_stage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
        appBar: AppBar(
            title:Text('Jobsy'),
            backgroundColor:const Color(0xFF126180),
            actions: [
              IconButton(onPressed:(){
                // Provider.of<JobData>(context, listen: false).deleteJob(currentJob);
                Navigator.pop(context);
              },
              icon:Icon(Icons.delete)),
              IconButton(onPressed: (){},
                  icon:Icon(Icons.more_vert))
            ]
        ),
        body:Padding(
          padding:const EdgeInsets.all(20),
          child:ListView(
            shrinkWrap: true,
            children: [
              Card(
              color: const Color(0xFFFFF5EE),
            elevation:20,
            child:Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  ClipRRect(// Image border
                      child: currentJob.company_logo==""?Image.asset('images/company.png',fit: BoxFit.fill,height:100):Image.network(currentJob.company_logo, fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  SizedBox(width: 20.0),
                  currentJob.company.length>30? Text(currentJob.company,style: TextStyle(fontSize: 25)):
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child:Text(currentJob.company,style: TextStyle(fontSize: 35))
                       ),
                ])
                   )
              ),
              IntrinsicHeight(child:
              Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Expanded(flex:1,
                    child:Container(
                      child: Card(
                          color: const Color(0xFFFFF5EE),
                          elevation:20,
                          child:Padding(
                              padding: const EdgeInsets.all(20),
                              child:Center(child: Text(currentJob.role ,style: TextStyle(fontSize: 20),textAlign: TextAlign.center))
                          )
                      ),
                    )
                ),
                Expanded(flex:1,
                    child:Container(
                      child: Card(
                          color: const Color(0xFFFFF5EE),
                          elevation:20,
                          child:Padding(
                              padding: const EdgeInsets.all(20),
                              child:Center(child: Text(currentJob.location ,style: TextStyle(fontSize: 20),textAlign: TextAlign.center))
                          )
                      ),
                    )
                ),

              ],)
        ),
              Container(
                child: Card(
                    color: const Color(0xFFFFF5EE),
                    elevation:20,
                    child:Padding(
                        padding: const EdgeInsets.all(20),
                        child:Row(children: [
                          Text('Stage: ' ,style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          DropdownButtonHideUnderline(
                              child:ButtonTheme(
                                  alignedDropdown: true,
                                  child:DropdownButton(
                                    hint:Text('Select Stage'),
                                    value: selected_stage,
                                    onChanged: (newValue){
                                      setState(() {
                                        newValue!=null?
                                        selected_stage=newValue:null;
                                      });
                                    },
                                    items: stagesList.map((stageItem){
                                      return DropdownMenuItem(
                                          value:stageItem['name'].toString(),
                                          child:Row(
                                              children:[
                                                Image.asset(stageItem['image'],width:35),
                                                SizedBox(width: 5),
                                                Container(
                                                    margin: EdgeInsets.only(left:10),
                                                    child:Text(stageItem['name'],style:TextStyle(fontSize: 20))
                                                )
                                              ]
                                          )
                                      );
                                    }).toList(),
                                  )
                              )
                          )

                        ],
                        )
                ),
              )
              )

            ],
          )

        )
    );
  }
}
