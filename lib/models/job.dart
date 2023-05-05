
class Job{
  final String id;
  final String company;
  final String role;
  final String location;
  String? url;
  String interview_stage;
  String? lastUpdated;
  String? company_photo;
  bool? archive;

  factory Job.fromJson(Map<String,dynamic> parsedJson){
    return Job(
        id:parsedJson['_id'],
        company:parsedJson['company'],
        role:parsedJson['role'],
        location:parsedJson['location'],
        url:parsedJson['url'].toString(),
        interview_stage:parsedJson['stage'],
        lastUpdated:parsedJson['updatedAt'],
        company_photo:parsedJson['company_photo'],
        archive:parsedJson['archive']


    );
  }



  Job({required this.id,required this.company, required this.role, required this.location,this.lastUpdated,required this.interview_stage,this.url,this.company_photo,  this.archive});

  void changeStage(String new_stage ){
    this.interview_stage=new_stage;
  }
}