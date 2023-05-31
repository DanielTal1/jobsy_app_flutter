import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment currentComment;
  CommentTile({required this.currentComment});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
        title:Text('username: '+currentComment.username+'    '+'role: '+currentComment.role),
        subtitle: Text(currentComment.text),

    );
  }
}
