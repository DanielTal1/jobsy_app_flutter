
class Job{
  final String id;
  final String company;
  final String role;
  final String location;
  String? url;
  String interview_stage;
  String? lastUpdated;
  String company_logo;
  // bool? archive;

  factory Job.fromJson(Map<String,dynamic> parsedJson){
    return Job(
        id:parsedJson['_id'],
        company:parsedJson['company'],
        role:parsedJson['role'],
        location:parsedJson['location'],
        url:parsedJson['url'].toString(),
        interview_stage:parsedJson['stage'],
        lastUpdated:parsedJson['updatedAt'],
        company_logo:parsedJson['company_logo'],
        // archive:parsedJson['archive']
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'company': company,
      'role': role,
      'location': location,
      'url': url,
      'stage': interview_stage,
      'updatedAt': lastUpdated,
      'company_logo': company_logo,
    };
  }





  Job({required this.id,required this.company, required this.role, required this.location, this.lastUpdated,required this.interview_stage, this.url,required this.company_logo});

  void changeStage(String new_stage ){
    this.interview_stage=new_stage;
  }
}