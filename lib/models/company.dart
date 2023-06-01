
class Company{
  final String name;
  final int rating;
  final String logo;
  final String description;


  factory Company.fromJson(Map<String,dynamic> parsedJson){
    return Company(
      name:parsedJson['name'],
      rating:parsedJson['rating'],
      logo:parsedJson['logo'],
      description:parsedJson['description'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'logo': logo,
      'description': description,
    };
  }





  Company({required this.name, required this.rating, required this.logo, required this.description});
}