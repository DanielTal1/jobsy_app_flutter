import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/add_comment_screen.dart';
import 'package:jobsy_app_flutter/models/comment_data.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import 'comment_tile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentList extends StatefulWidget {
  final String currentCompany;
  CommentList({required this.currentCompany});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {




  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentData>(context);
    commentProvider.fetchComments(widget.currentCompany);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '   Comments (${commentProvider.comments.length})',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: AddCommentScreen(currentCompany:widget.currentCompany),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Text('Add Comment'),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 250, // Set a fixed height for the comment section
              child: ListView.builder(
                itemCount: commentProvider.comments.length,
                itemBuilder: (context, index) {
                  return CommentTile(currentComment: commentProvider.comments[index]);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
