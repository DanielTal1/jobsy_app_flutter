
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsy_app_flutter/models/username_data.dart';
import 'dart:convert';

import 'comment.dart';


class CommentData extends ChangeNotifier{
  List<Comment> _comments = [];
  bool _isLoading = false;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;




  Future<void> fetchComments(String companyName) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/comments/' + companyName));
      final jsonData = json.decode(response.body) as List<dynamic>;
      _comments = jsonData.map((commentData) => Comment.fromJson(commentData)).toList();
    } catch (error) {
      throw error;
    }
  }



  Future<void> addComment(String company,String text,String role) async {
    String? username=await UsernameData.getUsername();
    if(username==null){
      return;
    }
    final url = Uri.parse('http://10.0.2.2:3000/comments');
    // Define the request body
    final requestBody = json.encode({
      'company': company,
      'username': username,
      'text': text,
      'role': role,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request succeeded
        print('Comment added successfully');
      } else {
        // Request failed
        print('Failed to add comment');
      }
    } catch (error) {
      // Error occurred
      print('Error: $error');
    }
  }

  Future<void> addCommentLocally(String company, String text, String role) async {
    String? username=await UsernameData.getUsername();
    if(username==null){
      return;
    }
    Comment newComment = Comment(
      company: company,
      username: username,
      text: text,
      role: role,
    );
    _comments.insert(0,newComment);
    notifyListeners();

  }

  void disposeComments(){
    _comments=[];
  }


}