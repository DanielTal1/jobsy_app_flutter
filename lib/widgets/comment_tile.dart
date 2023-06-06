import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment currentComment;
  CommentTile({required this.currentComment});

  @override
  Widget build(BuildContext context) {
    return  Column(children:[ListTile(
      title: Text(
        'username: '+currentComment.username+'       '+'Role: '+currentComment.role,
        style: TextStyle(
          fontSize: 15, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Adjust the font weight as needed
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 5), // Adjust the padding as needed
        child: Text(
          currentComment.text,
          style: TextStyle(
            fontSize: 15, // Same font size as the title
          ),
        ),
      ),
    ),
    Container(
    width: 250, // Adjust the width as needed
    child: Divider(
    height: 1,
    color: Colors.grey,
    )
    ),
      SizedBox(height: 6,)
    ]);
  }
}
