import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/comment_list.dart';
import 'package:provider/provider.dart';

import 'models/Job_data.dart';
import 'models/company.dart';
import 'models/job.dart';
import 'models/stage.dart';
import 'package:http/http.dart' as http;
class JobPage extends StatefulWidget {
  final Job currentJob;
  final bool isArchive;
  JobPage({required this.currentJob, required this.isArchive});


  @override
  State<JobPage> createState() => _JobPageState(currentJob: currentJob);
}

class _JobPageState extends State<JobPage> {
  final Job currentJob;
  _JobPageState({required this.currentJob});
  late Company currentCompany;
  late String selected_stage=currentJob.interview_stage;

  Future<void> fetchCompany(String companyName) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/company/' + companyName));
      final jsonData = json.decode(response.body) as List<dynamic>;
      setState(() {
        currentCompany = Company.fromJson(jsonData[0]);
      });
    } catch (error) {
      throw error;
    }
  }



  @override
  void initState() {
    super.initState();
    currentCompany=Company(
        name: currentJob.company,
        rating: 0,
        logo: currentJob.company_logo,
        description: ""
    );
    fetchCompany(currentJob.company);
  }

  Widget build(BuildContext context) {
    final jobData = Provider.of<JobData>(context, listen: false);
    return Scaffold(resizeToAvoidBottomInset : false,
        appBar: AppBar(
            title:Text('Jobsy'),
            backgroundColor:const Color(0xFF126180),
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
              if(currentCompany.description!="")Container(
                  child: Card(
                      color: const Color(0xFFFFF5EE),
                      elevation:20,
                      child:Padding(
                          padding: const EdgeInsets.all(20),
                          child:Center(child: Text(currentCompany.description ,style: TextStyle(fontSize: 20),textAlign: TextAlign.center))
                      )

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
                              child:Center(child: Text(currentJob.role ,style: TextStyle(fontSize: 15),textAlign: TextAlign.left))
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
                                    onChanged: (newValue) async {
                                      if(newValue!=null){
                                        setState(() {
                                          selected_stage=newValue;
                                        });
                                        jobData.updateStageLocally(newValue, currentJob.id,widget.isArchive?jobData.archiveJobs:jobData.jobs);
                                        jobData.updateJob(newValue,currentJob.id);
                                      }
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
              ),
              Card(
                color:const Color(0xFFFFF5EE),
                child:CommentList(currentCompany: currentJob.company),
              )

            ],
          )

        )
    );
  }
}
