import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import 'job_tile.dart';

class JobList extends StatelessWidget {
  String listName;
  JobList(this.listName);


  @override
  Widget build(BuildContext context) {
    return Consumer<JobData>(
      builder:(context,jobData,child){
        return ListView.builder(itemBuilder: (context,index){
          return JobTile(
            currentJob: listName=="All"?  jobData.jobsList[index]: jobData.JobsResult[index] ,
          );
        },
          itemCount:  listName=="All"? jobData.jobsList.length:jobData.JobsResult.length);
      },
    );
  }
}
