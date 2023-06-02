import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/job_page.dart';
import 'package:jobsy_app_flutter/models/job.dart';



class JobTile extends StatelessWidget {
  final Job currentJob;
  final Function addSelectedCallback;
  final Function removeSelectedCallback;
  final Function isSelectedListEmptyCallback;
  final Function isJobSelected;
  JobTile({required this.currentJob, required this.addSelectedCallback, required this.removeSelectedCallback, required this.isSelectedListEmptyCallback, required  this.isJobSelected});

  void onTapActions(context){
    if(isSelectedListEmptyCallback()){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>JobPage(currentJob: currentJob)));
    }
    else if (isJobSelected(currentJob)){
      removeSelectedCallback(currentJob);
    }
    else{
      addSelectedCallback(currentJob);
    }
  }

  void onLongPressActions(context){
    if(isJobSelected(currentJob)){
      removeSelectedCallback(currentJob);
    } else{
      addSelectedCallback(currentJob);
    }

  }
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title:Text(currentJob.role),
      trailing:Container(child:Row(children: [
        Column(
          children: [
            Text(currentJob.updatedAt),
            Text(currentJob.interview_stage),
            if (currentJob.pin) Icon(Icons.push_pin),
          ],
        ),
      ]),width:130.0),
      subtitle: Text(currentJob.company+" , "+currentJob.location),
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8), // Image border
        child: currentJob.company_logo==""?Image.asset('images/company.png',fit: BoxFit.cover,height: 50.0):Image.network(currentJob.company_logo, fit: BoxFit.cover,height: 50.0),
      ),
      onTap:()=> onTapActions(context),
      onLongPress:()=>onLongPressActions(context) ,
    );
  }
}



