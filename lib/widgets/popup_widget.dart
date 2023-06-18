import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Job_data.dart';
import '../models/job.dart';
import 'dart:math';
import '../models/stage.dart';
import 'package:confetti/confetti.dart';



class PopupWidget {

  //gets random tip for the new Stage from interviewTips
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

  //open a popup dialog
  static Future<void> openPopup(BuildContext context, String selected_stage, Job currentJob,bool isArchive, Function updateInterviewCallBack) async {
    final confettiDuration=5;
    final iconSize=30.0;
    final maxYear=2100;
    final smallPad=8.0;
    final font=15.0;
    final normalPad=16.0;
    final confettiPosition=0.0;
    final  confettiBlastDirection= -pi / 2;
    final  confettiEmissionFrequency= 0.05;
    final  confettiNumberOfParticles= 20;
    final  confettiMaxBlastForce= 5.0;
    final  confettiMinBlastForce= 2.0;
    final  confettiGravity= 0.1;
    DateTime selectedDate = DateTime.now();
    ConfettiController _confettiController = ConfettiController(duration: Duration(seconds: confettiDuration));
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
                        width: iconSize,
                        height: iconSize,
                      ),
                      SizedBox(width: smallPad),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(smallPad),
                          ),
                          padding:  EdgeInsets.all(smallPad),
                          margin:  EdgeInsets.only(bottom: normalPad),
                          child: Text(
                            chooseRandomTip(selected_stage),
                            style: TextStyle(fontSize: font),
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
                        width: iconSize,
                        height: iconSize,
                      ),

                      SizedBox(width: smallPad),
                      ElevatedButton(
                        onPressed: () async {
                          //opens the calendar
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(maxYear),
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
                    top: confettiPosition,
                    left: confettiPosition,
                    right: confettiPosition,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirection: confettiBlastDirection,
                        emissionFrequency: confettiEmissionFrequency,
                        numberOfParticles: confettiNumberOfParticles,
                        maxBlastForce: confettiMaxBlastForce,
                        minBlastForce: confettiMinBlastForce,
                        gravity: confettiGravity,
                      ),
                    ),
                  ),
              ]);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {//when closing the popup
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




