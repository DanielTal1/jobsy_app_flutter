import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/username_data.dart';


class AddJobScreen extends StatefulWidget {
  final Function addJobCallback;

  const AddJobScreen({super.key, required this.addJobCallback});


  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {

  static final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _role = TextEditingController();
  final _location = TextEditingController();
  late String addedCompany;
  late String addedRole;
  late String addedLocation;
  late Function addJobCallback;
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
  void initState() {
    super.initState();
    addJobCallback=widget.addJobCallback;
  }

  Future<void> postJob() async {
    String? username=await UsernameData.getUsername();
    if(username==null){
      return;
    }
    final url = Uri.parse('http://10.0.2.2:3000/jobs');
    final body = json.encode({
      "username": username,
      "company":addedCompany ,
      "role": addedRole,
      "location": addedLocation,
      "url":"",
      "source":"",
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Request successful
        print('Job created successfully');
      } else {
        // Request failed
        print('Failed to create job: ${response.statusCode}');
      }
    } catch (error) {
      // Error occurred during the request
      print('Error creating job: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      color: buttonColor,
      child: Container(
        padding: EdgeInsets.all(normalPad),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(normalPad),
            topRight: Radius.circular(normalPad),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding:  EdgeInsets.fromLTRB(normalPad, 0, normalPad, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: normalPad),
                Text('Add Job',
                    style:TextStyle(fontSize: fontSize,color:buttonColor)),
                SizedBox(height: smallPad),
                TextFormField(
                  onChanged: (newValue) => addedCompany = newValue,
                  controller: _company,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a company';
                    }
                    return null;
                  },
                ),
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
                  onChanged: (newValue) => addedLocation = newValue,
                  controller: _location,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: smallPad),
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
                          await postJob();
                          addJobCallback();
                        }
                      },
                      minWidth: buttonWidth,
                      height: buttonHeight,
                      child: Text(
                        'Add Job',
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