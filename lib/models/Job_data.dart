
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsy_app_flutter/models/username_data.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'job.dart';

class JobData extends ChangeNotifier {

  List<Job> _jobs = [];
  List<Job> _archiveJobs=[];
  bool _isLoading = false;
  bool _isLoadingArcive = false;
  List<Job> get jobs => _jobs;
  List<Job> get archiveJobs => _archiveJobs;
  bool get isLoading => _isLoading;
  bool get isLoadingArchive => _isLoadingArcive;




  void JobDataInitialize() {
    fetchJobs();
    fetchJobsArchive();
  }

  void JobDataExit(){
    _jobs.clear();
    _archiveJobs.clear();
  }


  Future<void> fetchJobs() async {
    _isLoading = true;
    String? username=await UsernameData.getUsername();
    if(username==null){
      return;
    }
    notifyListeners();
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/jobs/user/'+username));
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


  Future<void> fetchJobsArchive() async {
    _isLoadingArcive = true;
    String? username=await UsernameData.getUsername();
    if(username==null){
      return;
    }
    notifyListeners();
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/jobs/archive/'+username));
      final jsonData = json.decode(response.body) as List<dynamic>;
      _archiveJobs = jsonData.map((jobData) => Job.fromJson(jobData)).toList();
      _isLoadingArcive = false;
      notifyListeners();
    } catch (error) {
      _isLoadingArcive = false;
      notifyListeners();
      throw error;
    }
  }


  Future<void> deleteJobs(List<String> jobIds) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/jobs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jobIds),
      );
      if (response.statusCode == 200) {
        print('Jobs deleted successfully');
      } else {
        print('Failed to delete jobs');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteJobsLocally(List<String> jobIds,bool isArchive) {
    final listJobsToAdd=isArchive?jobs:archiveJobs;
    final listJobsToDelete=isArchive?archiveJobs:jobs;
    for (String jobId in jobIds) {
      listJobsToDelete.removeWhere((job) {
        if (job.id == jobId) {
          listJobsToAdd.add(job); // Add the job to listJobsToAdd
          return true; // Remove the job from listJobsToDelete
        }
        return false;
      });
    }
    sortJobs(listJobsToAdd);
    notifyListeners();
  }

  void updatePinsLocally(List<String> jobIds,List<Job> listJobs){
    for (String jobId in jobIds) {
      Job job=listJobs.firstWhere((job) => job.id == jobId);
      job.pin = !job.pin;
    }
    notifyListeners();
  }

  Future<void> updatePins(List<String> jobIds) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/jobs/pin/0'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jobIds),
      );
      if (response.statusCode == 200) {
        print('Pins updated successfully');
      } else {
        print('Failed to update pins');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  void sortJobs(List<Job> listJobs) {
    listJobs.sort((a, b) {
      if (a.pin == b.pin) {
        // If the pins are the same, sort by last_updated in descending order
        return b.last_updated.compareTo(a.last_updated);
      } else {
        // Sort by pin in descending order
        return b.pin ? 1 : -1;
      }
    });
    notifyListeners();
  }



  Future<void> updateArchive(List<String> jobIds) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/jobs/archive/0'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jobIds),
      );
      if (response.statusCode == 200) {
        print('Archive updated successfully');
      } else {
        print('Failed to update archive');
      }
    } catch (error) {
      print('Error: $error');
    }
  }



  Future<void> updateJob( String newStage,String jobId) async {
    final url = Uri.parse('http://10.0.2.2:3000/jobs/'+jobId);

    try {
      final response =await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'stage': newStage}),
      );
      if (response.statusCode == 200) {
        print('Job updated successfully');
      } else {
        print('Failed to update job. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating job: $error');
    }

  }





  void updateStageLocally(newStage,JobId,List<Job> listJobs){
     Job job=listJobs.firstWhere((job) => job.id == JobId);
     job.interview_stage = newStage;
     job.last_updated=DateTime.now();
     notifyListeners();
     sortJobs(listJobs);
  }











}
