import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment currentComment;
  final verySmallPad=5.0;
  final smallFontSize=15.0;
  final dividerWidth=250.0;
  final dividerHeight=1.0;
  CommentTile({required this.currentComment});

  @override
  Widget build(BuildContext context) {
    return  Column(children:[ListTile(
      title: Text(
        'Username: '+currentComment.username+'       '+'Role: '+currentComment.role,
        style: TextStyle(
          fontSize: smallFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: verySmallPad),
        child: Text(
          currentComment.text,
          style: TextStyle(
            fontSize: smallFontSize,
          ),
        ),
      ),
    ),
    Container(
    width: dividerWidth,
    child: Divider(
    height: dividerHeight,
    color: Colors.grey,
    )
    ),
      SizedBox(height: verySmallPad,)
    ]);
  }
}
