import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/models/Job_data.dart';
import 'package:provider/provider.dart';

import 'models/job.dart';

class AddJobScreen extends StatefulWidget {

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
                      onPressed: () {
                        if (_formKey.currentState!.validate()==true) {
                          final addedJob=Job(company:addedCompany,role:addedRole,location:addedLocation,interview_stage:"applied");
                          Provider.of<JobData>(context, listen: false).addJob(addedJob);
                          Navigator.pop(context);
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
