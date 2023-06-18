import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/add_comment_screen.dart';
import 'package:jobsy_app_flutter/models/comment_data.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import 'comment_tile.dart';

class CommentList extends StatefulWidget {
  final String currentCompany;

  CommentList({required this.currentCompany});

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<Comment> comments = [];
  final fontSize=20.0;
  final normalPad=20.0;
  final smallPad=10.0;
  final commentListHeight=300.0;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  void fetchComments() async {
    final commentProvider = Provider.of<CommentData>(context, listen: false);
    await commentProvider.fetchComments(widget.currentCompany);
    if(mounted){
      setState(() {
      comments = commentProvider.comments;
      });
    }
  }

  @override
  void dispose() {
    comments.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentData>(
      builder: (context, commentProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '   Comments (${comments.length})',
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
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
                                    topLeft: Radius.circular(normalPad),
                                    topRight: Radius.circular(normalPad),
                                  ),
                                ),
                                child: AddCommentScreen(
                                  currentCompany: widget.currentCompany,
                                ),
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
            SizedBox(height: smallPad),
            if (comments.isNotEmpty)
              Stack(
                children: [
                  Container(
                    height: commentListHeight,
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return CommentTile(currentComment: comments[index]);
                      },
                    ),
                  ),
                ],
              ),
            if (comments.isEmpty)
              Center(child: Text('No comments available')),
          ],
        );
      },
    );
  }
}
