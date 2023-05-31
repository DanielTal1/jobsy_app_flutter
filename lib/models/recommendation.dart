
class Recommendation{
  final String id;
  final String company;
  final String role;
  final String location;
  final String url;
  final String company_logo;


  factory Recommendation.fromJson(Map<String,dynamic> parsedJson){
    return Recommendation(
      id:parsedJson['_id'],
      company:parsedJson['company'],
      role:parsedJson['role'],
      location:parsedJson['location'],
      url:parsedJson['url'].toString(),
      company_logo:parsedJson['company_logo'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'company': company,
      'role': role,
      'location': location,
      'url': url,
      'company_logo': company_logo,
    };
  }





  Recommendation({required this.id,required this.company, required this.role, required this.location, required this.url,required this.company_logo});
}