import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/comment_data.dart';


class AddCommentScreen extends StatefulWidget {
  final String currentCompany;

  const AddCommentScreen({super.key, required this.currentCompany});


  @override
  State<AddCommentScreen> createState() => _AddCommentScreen();
}

class _AddCommentScreen extends State<AddCommentScreen> {

  static final _formKey = GlobalKey<FormState>();
  final _role = TextEditingController();
  final _text = TextEditingController();
  late String addedRole;
  late String addedText;

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentData>(context);
    return Container(
      color: const Color(0xFFFFF5EE),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color:const Color(0xFFFFF5EE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Text('Add Comment',
                    style:TextStyle(fontSize: 20.0,color:Color(0xFF0077c0))),
                SizedBox(height: 10.0),
                SizedBox(height: 5.0),
                TextFormField(
                  onChanged: (newValue) => addedRole = newValue,
                  controller: _role,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Role',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Role';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  onChanged: (newValue) => addedText = newValue,
                  controller: _text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Text',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your comment';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 40,
                  width: double.infinity,
                  // height: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Material(
                    color: Color(0xFF0077c0),
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()==true) {
                          Navigator.pop(context);
                          await commentProvider.addCommentLocally(widget.currentCompany,addedText,addedRole);
                          commentProvider.addComment(widget.currentCompany,addedText,addedRole);
                        }
                      },
                      minWidth: 40.0,
                      height: 42.0,
                      child: Text(
                        'Add Comment',
                      ),

                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}