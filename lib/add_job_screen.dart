import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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

  @override
  void initState() {
    super.initState();
    addJobCallback=widget.addJobCallback;
  }

  Future<void> postJob() async {
    final url = Uri.parse('http://10.0.2.2:3000/jobs'); // Change the URL accordingly for Android emulator
    final body = json.encode({
      "username": 'ravid',
      "company":addedCompany ,
      "role": addedRole,
      "location": addedLocation,
      "url":""
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
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
                Text('Add Job',
                    style:TextStyle(fontSize: 20.0,color:Color(0xFF0077c0))),
                SizedBox(height: 10.0),
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
                          await postJob();
                          addJobCallback();
                        }
                      },
                      minWidth: 40.0,
                      height: 42.0,
                      child: Text(
                        'Add Job',
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