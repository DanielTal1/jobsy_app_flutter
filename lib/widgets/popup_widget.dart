import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import '../models/job.dart';
import 'dart:math';
import '../models/stage.dart';
import 'package:confetti/confetti.dart';



class PopupWidget {
  static String chooseRandomTip(String stage) {
    List<String>? tips = interviewTips[stage];
    if (tips != null && tips.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(tips.length);
      return tips[randomIndex];
    } else {
      return 'No tips available for this stage.';
    }
  }

  static Future<void> openPopup(BuildContext context, String selected_stage, Job currentJob,bool isArchive,  Function updateInterviewCallBack) async {
    DateTime selectedDate = DateTime.now();
    print(selected_stage);
    ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    final jobData = Provider.of<JobData>(context, listen: false);
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        _confettiController.play();
        return AlertDialog(
          title: Center(
            child: const Text('Congratulations!'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Stack(
                children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'images/tips.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            chooseRandomTip(selected_stage),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if(selected_stage!="Offer")
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'images/calender.png',
                        width: 30,
                        height: 30,
                      ),

                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null && pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: const Text('Interview date'),
                      ),
                    ],
                  ),
                ],
              ), Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirection: -pi / 2,
                        emissionFrequency: 0.05,
                        numberOfParticles: 20,
                        maxBlastForce: 5,
                        minBlastForce: 2,
                        gravity: 0.1,
                      ),
                    ),
                  ),
              ]);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _confettiController.stop();
                jobData.updateStageLocally(selected_stage, currentJob.id,isArchive?jobData.archiveJobs:jobData.jobs,selectedDate);
                updateInterviewCallBack(selectedDate);
                jobData.updateJob(selected_stage,currentJob.id,selectedDate);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}




