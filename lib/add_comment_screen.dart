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
  final backgroundColor=Color(0xFFFFF5EE);
  final buttonColor=Color(0xFF0077c0);
  final fontSize=20.0;
  final normalPad=20.0;
  final bigPad=30.0;
  final smallPad=10.0;
  final verySmallPad=5.0;
  final buttonHeight=42.0;
  final buttonWidth=42.0;

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentData>(context);
    return Container(
      color: backgroundColor,
      child: Container(
        padding: EdgeInsets.all(normalPad),
        decoration: BoxDecoration(
          color:backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(normalPad),
            topRight: Radius.circular(normalPad),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(normalPad, 0, normalPad, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: normalPad),
                Text('Add Comment',
                    style:TextStyle(fontSize: fontSize,color:buttonColor)),
                SizedBox(height:smallPad),
                SizedBox(height: verySmallPad),
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
                SizedBox(height: verySmallPad),
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
                SizedBox(height:smallPad),
                Container(
                  height: buttonHeight,
                  width: double.infinity,
                  // height: double.infinity,
                  padding:  EdgeInsets.fromLTRB(smallPad, 0, smallPad, 0),
                  child: Material(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(bigPad),
                    elevation: verySmallPad,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()==true) {
                          Navigator.pop(context);
                          await commentProvider.addCommentLocally(widget.currentCompany,addedText,addedRole);
                          commentProvider.addComment(widget.currentCompany,addedText,addedRole);
                        }
                      },
                      minWidth: buttonWidth,
                      height: buttonHeight,
                      child: Text(
                        'Add Comment',
                      ),

                    ),
                  ),
                ),
                SizedBox(height: normalPad),
              ],
            ),
          ),
        ),
      ),
    );
  }
}