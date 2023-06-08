import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/job_page.dart';
import 'package:jobsy_app_flutter/models/job.dart';


class JobTile extends StatelessWidget {
  final Job currentJob;
  final Function addSelectedCallback;
  final Function removeSelectedCallback;
  final Function isSelectedListEmptyCallback;
  final Function isJobSelected;
  final bool isArchive;

  JobTile({
    required this.currentJob,
    required this.addSelectedCallback,
    required this.removeSelectedCallback,
    required this.isSelectedListEmptyCallback,
    required this.isJobSelected,
    required this.isArchive,
  });

  void onTapActions(context) {
    if (isSelectedListEmptyCallback()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobPage(currentJob: currentJob, isArchive: isArchive),
        ),
      );
    } else if (isJobSelected(currentJob)) {
      removeSelectedCallback(currentJob);
    } else {
      addSelectedCallback(currentJob);
    }
  }

  void onLongPressActions(context) {
    if (isJobSelected(currentJob)) {
      removeSelectedCallback(currentJob);
    } else {
      addSelectedCallback(currentJob);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 3,),
        Container(
        height: 80.0, // Set the desired height
        child: ListTile(
          title: Text(
            currentJob.role,
            maxLines: 2, // Maximum of 2 lines
            overflow: TextOverflow.ellipsis, // Truncate with "..."
          ),
          trailing: Container(
            child:Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(currentJob.updatedAt),
                    Text(currentJob.interview_stage),
                    if (currentJob.pin) Icon(Icons.push_pin),
                  ],
                ),
              ],
            )),
            width: 130.0,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentJob.company,
                maxLines: 1, // Maximum of 2 lines
                overflow: TextOverflow.ellipsis, // Truncate with "..."
              ),
              Text(
                currentJob.location,
                maxLines: 1, // Maximum of 2 lines
                overflow: TextOverflow.ellipsis, // Truncate with "..."
              ),
              SizedBox(height: 10,),
            ],
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: currentJob.company_logo == ""
                ? Image.asset(
              'images/company.png',
              fit: BoxFit.cover,
              height: 60.0,
              width: 55,
            )
                : Image.network(
              currentJob.company_logo,
              fit: BoxFit.cover,
              height: 60.0,
              width: 55,
            ),
          ),
          onTap: () => onTapActions(context),
          onLongPress: () => onLongPressActions(context),
        )),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 7,),
      ],
    );
  }
}



