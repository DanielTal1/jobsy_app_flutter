
class Comment{
  final String company;
  final String text;
  final String username;
  final String role;


  factory Comment.fromJson(Map<String,dynamic> parsedJson){
    return Comment(
      company:parsedJson['company'],
      role:parsedJson['role'],
      text:parsedJson['text'],
      username:parsedJson['username'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'text': text,
      'username': username,
    };
  }





  Comment({required this.company, required this.role, required this.text, required this.username});
}