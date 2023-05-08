import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import '../models/job.dart';
import 'job_tile.dart';

class JobList extends StatefulWidget {
  final searchedQuery;

  const JobList({super.key, required this.searchedQuery});

  @override
  State<JobList> createState() => _JobListState(searchedQuery:searchedQuery);
}

class _JobListState extends State<JobList> {
  late String searchedQuery;

  _JobListState({required this.searchedQuery});

  @override
  void initState() {
    super.initState();
    searchedQuery = widget.searchedQuery;
  }



  bool jobCheck(String query,Job currentJob) {
    final company = currentJob.company.toLowerCase();
    final role = currentJob.role.toLowerCase();
    final input = query.toLowerCase();
    return role.contains(input) || company.contains(input);
  }

  @override
  Widget build(BuildContext context) {


    final jobProvider = Provider.of<JobData>(context);
    final shownJobs = jobProvider.jobs.where((job) => jobCheck(searchedQuery,job)).toList();


    return jobProvider.isLoading ? Center(child: CircularProgressIndicator()) :
    ListView.builder(itemBuilder: (context, index) {
      return JobTile(
          currentJob: shownJobs[index]
      );
    },
        itemCount: shownJobs.length
    );
  }

  @override
  void didUpdateWidget(JobList oldWidget) {
    super.didUpdateWidget(oldWidget);
    searchedQuery = widget.searchedQuery;
  }
}
