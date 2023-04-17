
class Job{
  final String company;
  final String role;
  final String location;
  String? url;
  String interview_stage;
  String? addedTime;



  Job({required this.company, required this.role, required this.location,this.addedTime,required this.interview_stage,this.url});

  void changeStage(String new_stage ){
    this.interview_stage=new_stage;
  }
}