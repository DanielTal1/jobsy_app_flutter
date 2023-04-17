

import 'package:flutter/foundation.dart';

import 'job.dart';

class JobData extends ChangeNotifier{
  List<Job> jobsList=[
    Job(company:"amazon",role:"Backend Software Engineer-DevEx Teamssss",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"applied"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"applied"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"applied"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"1st interview"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"Offer"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"2nd interview"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"4th interview"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"applied"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"applied"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"applied"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"applied"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"applied"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"applied"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"applied"),
    Job(company:"amazon",role:"developer",location:"Tel-aviv",addedTime:"25/3/2022",interview_stage:"applied"),
    Job(company:"microsoft",role:"qa",location:"Tel-aviv", addedTime: "18/11/2023",interview_stage:"applied"),
  ];
  late List<Job> JobsResult=jobsList;
  String currentQuery='';




  void addJob(Job new_job){
    jobsList.insert(0,new_job);
    currentQuery!=''&& jobCheck(currentQuery,new_job)? JobsResult.insert(0,new_job):null;
    notifyListeners();
  }


  void updateStage(Job new_job,String new_stage){
    new_job.changeStage(new_stage);
    notifyListeners();
  }

  void searchJob(String query){
    currentQuery=query;
    JobsResult=jobsList.where((job){
      return jobCheck(query,job);
    }).toList();
    notifyListeners();
  }

  bool jobCheck(String query,Job currentJob){
    final company=currentJob.company.toLowerCase();
    final role=currentJob.role.toLowerCase();
    final input=query.toLowerCase();
    return role.contains(input)||company.contains(input);
  }

  void setQuery(){
    currentQuery='';
    JobsResult=jobsList;
  }
}