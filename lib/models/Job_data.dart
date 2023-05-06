
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'job.dart';

class JobData extends ChangeNotifier{
  List<Job> _jobs = [];
  bool _isLoading = false;
  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;
  late List<Job> JobsResult=_jobs;
  String currentQuery='';

  JobData() {
    fetchJobs();
    JobsResult=_jobs;
  }

  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/jobs/user/ronaldo'));
      final jsonData = json.decode(response.body) as List<dynamic>;
      _jobs = jsonData.map((jobData) => Job.fromJson(jobData)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw error;
    }
  }


  // void updateJobLIst(){
  //
  // }

  // void addJob(Job new_job){
  //   jobsList.insert(0,new_job);
  //   currentQuery!=''&& jobCheck(currentQuery,new_job)? JobsResult.insert(0,new_job):null;
  //   notifyListeners();
  // }
  //
  // void deleteJob(Job deleted_job){
  //   jobsList.removeWhere((job) => job.company == deleted_job.company &&
  //       job.role == deleted_job.role && job.location == deleted_job.location &&
  //       job.interview_stage == deleted_job.interview_stage);
  //   currentQuery!=''&& jobCheck(currentQuery,deleted_job)?
  //   JobsResult.removeWhere((job) => job.company == deleted_job.company &&
  //       job.role == deleted_job.role && job.location == deleted_job.location &&
  //       job.interview_stage == deleted_job.interview_stage):null;
  //   notifyListeners();
  // }


  // void updateStage(Job new_job,String new_stage){
  //   new_job.changeStage(new_stage);
  //   notifyListeners();
  // }

  void searchJob(String query){
    currentQuery=query;
    JobsResult=_jobs.where((job){
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
    JobsResult=_jobs;
  }

  int getCount(){
    return JobsResult.length;
  }
}