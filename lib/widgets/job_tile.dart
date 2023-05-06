import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/job_page.dart';
import 'package:jobsy_app_flutter/models/job.dart';



class JobTile extends StatelessWidget {
  final Job currentJob;
  JobTile({required this.currentJob});
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title:Text(currentJob.role),
      trailing:Container(child:Row(children: [
        Column(children: [
          // Text(currentJob.lastUpdated),
          Text(currentJob.interview_stage)]
      ),
      ]),width:130.0),
      subtitle: Text(currentJob.company+" , "+currentJob.location),
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8), // Image border
        child: currentJob.company_logo==""?Image.asset('images/company.png',fit: BoxFit.cover,height: 50.0):Image.network(currentJob.company_logo, fit: BoxFit.cover,height: 50.0),
        ),
      onTap:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>
        JobPage(currentJob: currentJob)
      )),
      );
  }
}



