import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment currentComment;
  final double verySmallPad = 5.0;
  final double smallFontSize = 15.0;
  final double dividerWidth = 250.0;
  final double dividerHeight = 1.0;

  CommentTile({required this.currentComment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                'Username: ',
                style: TextStyle(
                  fontSize: smallFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  currentComment.username,
                  style: TextStyle(
                    fontSize: smallFontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: verySmallPad), // Adjust the spacing between username and role
              Text(
                'Role: ',
                style: TextStyle(
                  fontSize: smallFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  currentComment.role,
                  style: TextStyle(
                    fontSize: smallFontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
          ),
        ),
        SizedBox(height: verySmallPad),
      ],
    );
  }
}

