
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'job.dart';

class JobData extends ChangeNotifier {
  List<Job> _jobs = [];
  bool _isLoading = false;

  List<Job> get jobs => _jobs;

  bool get isLoading => _isLoading;

  JobData() {
    fetchJobs();
  }


  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/jobs/user/ravid'));
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

  void updateStage(newStage,JobId){
     Job job=jobs.firstWhere((job) => job.id == JobId);
     job.interview_stage = newStage;
     jobs.remove(job);
     jobs.insert(0,job);
     notifyListeners();
  }

}
