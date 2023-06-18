
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
  List<Job> get jobs => _jobs; //getter method
  List<Job> get archiveJobs => _archiveJobs;
  bool get isLoading => _isLoading;
  bool get isLoadingArchive => _isLoadingArcive;




  void JobDataInitialize() {
    //initialize job data by fetching jobs and archive jobs
    fetchJobs();
    fetchJobsArchive();
  }

  void JobDataExit(){
    //clear job data when exiting
    _jobs.clear();
    _archiveJobs.clear();
  }


  Future<void> fetchJobs() async {
    //fetch jobs from the server for the current user
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
    //fetch archived jobs from the server for the current user
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
    //delete jobs from the server based on the given job ids
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

  void archiveJobsLocally(List<String> jobIds,bool isArchive) {
    //move jobs from or to archive locally based on the given job IDs and the flag isArchive
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

  void deleteJobsLocally(List<String> jobIds,bool isArchive) {
    //delete jobs locally based on the given job is and the flag isArchive
    final listJobsToDelete=isArchive?archiveJobs:jobs;
    for (String jobId in jobIds) {
      listJobsToDelete.removeWhere((job) {
        if (job.id == jobId) {
          return true; // Remove the job from listJobsToDelete
        }
        return false;
      });
    }
    notifyListeners();
  }



  void updatePinsLocally(List<String> jobIds,List<Job> listJobs){
    //update pins locally for the given job ids
    for (String jobId in jobIds) {
      Job job=listJobs.firstWhere((job) => job.id == jobId);
      job.pin = !job.pin;
    }
    notifyListeners();
  }

  Future<void> updatePins(List<String> jobIds) async {
    //update pins on the server for the given job IDs
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
    //sort the list of jobs based on pin and last_updated
    listJobs.sort((a, b) {
      if (a.pin == b.pin) {
        //if the pins are the same, sort by last_updated in descending order
        return b.last_updated.compareTo(a.last_updated);
      } else {
        //sort by pin in descending order
        return b.pin ? 1 : -1;
      }
    });
    notifyListeners();
  }



  Future<void> updateArchive(List<String> jobIds) async {
    //update archive status on the server for the given job ids
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



  Future<void> updateJob( String newStage,String jobId,DateTime interviewDate) async {
    //update the stage and next interview date of a job on the server
    final url = Uri.parse('http://10.0.2.2:3000/jobs/'+jobId);

    try {
      final response =await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'stage': newStage,'next_interview':interviewDate.toIso8601String()}),
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

  void updateStageLocally(newStage,JobId,List<Job> listJobs,DateTime interviewDate){
    //update the stage, last_updated, and next_interview locally for a specific job
     Job job=listJobs.firstWhere((job) => job.id == JobId);
     job.interview_stage = newStage;
     job.last_updated=DateTime.now();
     job.next_interview=interviewDate;
     sortJobs(listJobs);
     notifyListeners();
  }


  Future<void> postJob(String addedCompany,String addedRole,String addedLocation) async {
    String? username=await UsernameData.getUsername();
    if(username==null){
      return;
    }
    final url = Uri.parse('http://10.0.2.2:3000/jobs');
    final body = json.encode({
      "username": username,
      "company":addedCompany ,
      "role": addedRole,
      "location": addedLocation,
      "url":"",
      "source":"",
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Request successful
        print('Job created successfully');
      } else {
        // Request failed
        print('Failed to create job: ${response.statusCode}');
      }
    } catch (error) {
      // Error occurred during the request
      print('Error creating job: $error');
    }
  }


}
