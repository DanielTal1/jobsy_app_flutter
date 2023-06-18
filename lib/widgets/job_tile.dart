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
  final verySmallPad=3.0;
  final dividerHeight=2.0;
  final roleMaxLines=2;
  final companyAndLocationMaxLines=1;
  final containerHeight=80.0;
  final smallPad=10.0;
  final trialingWidth=130.0;
  final iconWidth=55.0;
  final iconHeight=60.0;


  JobTile({
    required this.currentJob,
    required this.addSelectedCallback,
    required this.removeSelectedCallback,
    required this.isSelectedListEmptyCallback,
    required this.isJobSelected,
    required this.isArchive,
  });

  //function that handles short tap on jobTile
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

  //function that handles long tap on jobTile
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
        SizedBox(height: verySmallPad,),
        Container(
        height: containerHeight,
        child: ListTile(
          title: Text(
            currentJob.role,
            maxLines: roleMaxLines, // Maximum of 2 lines
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
            width: trialingWidth,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentJob.company,
                maxLines: companyAndLocationMaxLines, // Maximum of 1 lines
                overflow: TextOverflow.ellipsis, // Truncate with "..."
              ),
              Text(
                currentJob.location,
                maxLines: companyAndLocationMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: smallPad,),
            ],
          ),
          leading:  Container(
            width: iconWidth,
            child: Align(
            alignment: Alignment.center,child:ClipRRect(
            borderRadius: BorderRadius.circular(smallPad),
            child: currentJob.company_logo == ""
                ? Image.asset(
              'images/company.png',
              fit: BoxFit.cover,
              height: iconHeight,
              width: iconWidth,
            )
                : Image.network(
              currentJob.company_logo,
              fit: BoxFit.cover,
              height: iconHeight,
              width: iconWidth,
            ),
          ))),
          onTap: () => onTapActions(context),
          onLongPress: () => onLongPressActions(context),
        )),
        SizedBox(height: verySmallPad,),
        Divider(
          height: dividerHeight,
          color: Colors.grey,
        ),
      ],
    );
  }
}



