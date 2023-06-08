
class Job{
  final String id;
  final String company;
  final String role;
  final String location;
  String? url;
  String interview_stage;
  String updatedAt;
  String company_logo;
  bool archive;
  bool pin;
  DateTime last_updated;
  DateTime created_at;
  DateTime next_interview;

  factory Job.fromJson(Map<String,dynamic> parsedJson){
    return Job(
        id:parsedJson['_id'],
        company:parsedJson['company'],
        role:parsedJson['role'],
        location:parsedJson['location'],
        url:parsedJson['url'].toString(),
        interview_stage:parsedJson['stage'],
        updatedAt:parsedJson['updatedAt'],
        company_logo:parsedJson['company_logo'],
        archive:parsedJson['archive'],
        pin:parsedJson['pin'],
        last_updated:DateTime.parse(parsedJson['last_updated']),
        created_at:DateTime.parse(parsedJson['created_at']),
        next_interview: DateTime.parse(parsedJson['next_interview'])
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
      'updatedAt': updatedAt,
      'company_logo': company_logo,
      'archive': archive,
      'pin': pin,
      'last_updated':last_updated,
      'created_at':created_at,
      'next_interview':next_interview
    };
  }





  Job({required this.id,required this.company, required this.role, required this.location, required this.updatedAt,required this.interview_stage, this.url,required this.company_logo, required this.archive,required this.pin, required this.last_updated, required this.created_at, required this.next_interview});

  void changeStage(String new_stage ){
    this.interview_stage=new_stage;
  }
}