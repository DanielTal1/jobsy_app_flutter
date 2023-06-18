import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/widgets/comment_list.dart';
import 'package:jobsy_app_flutter/widgets/popup_widget.dart';
import 'package:intl/intl.dart';
import 'models/company.dart';
import 'models/job.dart';
import 'models/stage.dart';
import 'package:http/http.dart' as http;

import 'models/url_data.dart';
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
  late bool isPopup=false;
  final defaultColor=Color(0xFFFFF5EE);
  final cardElevation=20.0;//shadow effect
  final defaultPad=20.0;
  final defaultFont=20.0;
  final smallPad=10.0;
  final verySmallPad=5.0;
  final iconSize=100.0;
  final DropdownMenuwidth=35.0;
  final bigFont=30.0;
  final circularRadius=15.0;
  final appbarColor=Color(0xFF126180);



  void updateInterviewCallBack(DateTime next_interview){
    setState(() {
      currentJob.next_interview=next_interview;
    });

  }

  //gets the company data from server with http request
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
        logo: currentJob.company_logo,
        description: ""
    );
    fetchCompany(currentJob.company);
  }

  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,
        appBar: AppBar(
            title:Text('Jobsy'),
            backgroundColor:appbarColor,
        ),
        body:Padding(
          padding:EdgeInsets.all(defaultPad),
          child:ListView(
            shrinkWrap: true,
            children: [
              Card( //first card-name and logo
              color: defaultColor,
            elevation:cardElevation,
            child:Padding(
                padding: EdgeInsets.all(defaultPad),
                child: Row(children: [
                  ClipRRect(// Image border
                      child: currentJob.company_logo==""?
                      Image.asset('images/company.png',fit: BoxFit.fill,height:iconSize,width:iconSize) :
                      Image.network(currentJob.company_logo, fit: BoxFit.fill,height:iconSize,width:iconSize),
                      borderRadius: BorderRadius.circular(circularRadius)
                  ),
                  SizedBox(width: defaultPad),
                  Expanded(
                      child:Container(
                            child:Padding(
                                padding:  EdgeInsets.all(verySmallPad),
                                child:Center(child: Text(currentJob.company ,style: TextStyle(fontSize: bigFont),textAlign: TextAlign.left))
                            )
                      )
                  ),
                ])
                   )
              ),
              if(currentCompany.description!="")Container(
                  child: Card(//second card-showing description if exists
                      color: defaultColor,
                      elevation:cardElevation,
                      child:Padding(
                          padding:  EdgeInsets.all(defaultPad),
                          child:Center(child: Text(currentCompany.description ,
                              style: TextStyle(fontSize: defaultFont),textAlign: TextAlign.center)
                          )
                      )

                  )
              ),
              IntrinsicHeight(child:
              Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [//role and location
                Expanded(flex:1,
                    child:Container(
                      child: Card(
                          color: defaultColor,
                          elevation:cardElevation,
                          child:Padding(
                              padding:  EdgeInsets.all(defaultPad),
                              child:Center(child: Text(currentJob.role ,
                                  style: TextStyle(fontSize: defaultFont),textAlign: TextAlign.left)
                              )
                          )
                      ),
                    )
                ),
                Expanded(flex:1,
                    child:Container(
                      child: Card(
                          color: defaultColor,
                          elevation:cardElevation,
                          child:Padding(
                              padding: EdgeInsets.all(defaultPad),
                              child:Center(child: Text(currentJob.location ,
                                  style: TextStyle(fontSize: defaultFont),textAlign: TextAlign.center))
                          )
                      ),
                    )
                ),

              ],)
              ),
              if(currentJob.url!="")IntrinsicHeight(child:
              Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [//showing url and last updated if url exists
                  Expanded(flex:1,
                      child:Container(
                          child: Card(
                              color: defaultColor,
                              elevation:cardElevation,
                              child:Padding(
                                  padding:  EdgeInsets.all(smallPad),
                                  child:Center(child: TextButton(
                                    onPressed: () {
                                      UrlData.launchUrlFun(currentJob.url,context);
                                    },
                                    child: Text('Job link',style: TextStyle(fontSize: defaultFont)),
                                  ))
                              )

                          )
                      ),
                  ),
                  Expanded(flex:1,
                      child:Container(
                        child: Card(
                            color: defaultColor,
                            elevation:cardElevation,
                             child:Padding(
                                padding:  EdgeInsets.all(defaultPad),
                                child:Center(child: Text('last update: '+currentJob.updatedAt ,
                                    style: TextStyle(fontSize: defaultFont),textAlign: TextAlign.center))
                            )
                        ),
                      )
                  ),

                ],)
              ),
              Container(
                child: Card(//showing stage
                    color: defaultColor,
                    elevation:cardElevation,
                    child:Padding(
                        padding:  EdgeInsets.all(defaultPad),
                        child:Row(children: [
                          Text('Stage: ' ,style: TextStyle(fontSize: defaultFont)),
                          SizedBox(width: smallPad),
                          DropdownButtonHideUnderline(//lists the optional stages
                              child:ButtonTheme(
                                  alignedDropdown: true,
                                  child:DropdownButton(
                                    value: selected_stage,
                                    onChanged: (newValue) async {
                                      if(newValue!=null){
                                        //if value changed open popup
                                        if(selected_stage!=newValue){
                                          PopupWidget.openPopup(context,newValue,
                                              currentJob,widget.isArchive,updateInterviewCallBack);
                                        }
                                        setState(() {
                                          selected_stage=newValue;

                                        });
                                      }
                                    },
                                    items: stagesList.map((stageItem){
                                      return DropdownMenuItem( //for the stage update menu
                                          value:stageItem['name'].toString(),
                                          child:Row(
                                              children:[
                                                Image.asset(stageItem['image'],width:DropdownMenuwidth),
                                                SizedBox(width: verySmallPad),
                                                Container(
                                                    margin: EdgeInsets.only(left:smallPad),
                                                    child:Text(stageItem['name'],style:TextStyle(fontSize: defaultFont))
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
              if(currentJob.next_interview.isAfter(DateTime.now())) //showing next_interview if exists
                Card(
                  color:defaultColor,
                  elevation:cardElevation,
                  child:Padding(
                      padding:  EdgeInsets.all(defaultPad),
                      child:Center(child: Text('next interview: '+DateFormat('dd/MM/yy').format(currentJob.next_interview),
                          style: TextStyle(fontSize: defaultFont),textAlign: TextAlign.center))
                  ),
                ),
              Card(
                color:defaultColor,
                elevation:cardElevation,
                child:CommentList(currentCompany: currentJob.company),
              )

            ],
          )

        )
    );
  }
}
