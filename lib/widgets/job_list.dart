import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import '../models/job.dart';
import 'job_tile.dart';

class JobList extends StatefulWidget {
  final searchedQuery;
  final selectedStage;
  final Function addSelectedCallback;
  final Function isJobSelected;
  final Function removeSelectedCallback;
  final Function isSelectedListEmptyCallback;
  final bool isArchive;

  const JobList({
    Key? key,
    required this.searchedQuery,
    required this.selectedStage,
    required this.addSelectedCallback,
    required this.isJobSelected,
    required this.removeSelectedCallback,
    required this.isSelectedListEmptyCallback,
    required this.isArchive,
  }) : super(key: key);

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late String searchedQuery;
  late String selectedStage;
  late Function addSelectedCallback;
  late Function isJobSelected;
  late List<Job> selectedJobs;
  late Function removeSelectedCallback;
  late Function isSelectedListEmptyCallback;

  @override
  void initState() {
    super.initState();
    searchedQuery = widget.searchedQuery;
    selectedStage = widget.selectedStage;
    addSelectedCallback = widget.addSelectedCallback;
    isJobSelected=widget.isJobSelected;
    removeSelectedCallback=widget.removeSelectedCallback;
    isSelectedListEmptyCallback=widget.isSelectedListEmptyCallback;
  }

  //function to check if a job matches the search query and selected stage
  bool jobCheck(String query, Job currentJob) {
    final company = currentJob.company.toLowerCase();
    final role = currentJob.role.toLowerCase();
    final input = query.toLowerCase();
    final isSearch = role.contains(input) || company.contains(input);
    final isStage = selectedStage == '' || selectedStage == currentJob.interview_stage;
    return isSearch && isStage;
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobData>(context);
    final jobsList = widget.isArchive ? jobProvider.archiveJobs : jobProvider.jobs;
    final isLoading = widget.isArchive ? jobProvider.isLoading : jobProvider.isLoadingArchive;
    final shownJobs = jobsList
        .where((job) => jobCheck(searchedQuery, job)).toList();
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemBuilder: (context, index) {
        final currentJob = shownJobs[index];
        final isSelected = isJobSelected(currentJob);

        return Container(
          color: isSelected ? Colors.blueGrey : Colors.transparent,
          child: JobTile(
            currentJob: currentJob,
            addSelectedCallback: addSelectedCallback,
            removeSelectedCallback: removeSelectedCallback,
            isSelectedListEmptyCallback: isSelectedListEmptyCallback,
            isJobSelected: isJobSelected,
            isArchive: widget.isArchive,
          ),
        );
      },
      itemCount: shownJobs.length,
    );
  }


  //called when the stateful widget is rebuilt with a new instance of the widget
  //when a new query or stage sent by home_page this function is called
  @override
  void didUpdateWidget(JobList oldWidget) {
    super.didUpdateWidget(oldWidget);
    searchedQuery = widget.searchedQuery;
    selectedStage = widget.selectedStage;
  }
}
