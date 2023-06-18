
class Company{
  final String name;
  final String logo;
  final String description;


  factory Company.fromJson(Map<String,dynamic> parsedJson){
    return Company(
      name:parsedJson['name'],
      logo:parsedJson['logo'],
      description:parsedJson['description'],
    );
  }



  Company({required this.name, required this.logo, required this.description});
}