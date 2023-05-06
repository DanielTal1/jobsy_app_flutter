import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import 'job_tile.dart';

class JobList extends StatelessWidget {
  String listName;
  JobList(this.listName);


  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobData>(context);
    final jobs = jobProvider.jobs;
    final resultJobs=jobProvider.JobsResult;
    return jobProvider.isLoading ? Center(child: CircularProgressIndicator()) :
    ListView.builder(itemBuilder: (context, index) {
      return JobTile(
          currentJob:  listName=="All"?jobs[index]:resultJobs[index]
      );
    },
      itemCount: listName=="All"?jobs.length:resultJobs.length
    );
  }
}