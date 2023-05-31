import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/add_comment_screen.dart';
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
  List<Comment> comments = [];

  Future<void> fetchComments(String companyName) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/comments/' + companyName));
      final jsonData = json.decode(response.body) as List<dynamic>;
      setState(() {
        comments = jsonData.map((commentData) => Comment.fromJson(commentData)).toList();
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchComments(widget.currentCompany);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '   Comments (${comments.length})',
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
                            child: AddCommentScreen(),
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
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentTile(currentComment: comments[index]);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
