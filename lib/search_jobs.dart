import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Job_data.dart';

class SearchJobs extends StatefulWidget {
  final Function callbackFunc;
  SearchJobs(this.callbackFunc);
  @override
  State<SearchJobs> createState() => _SearchJobsState(callbackFunc);
}

class _SearchJobsState extends State<SearchJobs> {
  final Function callbackFunc;
  _SearchJobsState(this.callbackFunc);
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
          child:
            TextField(
                style: TextStyle(color: Colors.white),
                autofocus:true,
              controller:_searchController ,
              decoration: InputDecoration(
                prefixIcon: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
                  Provider.of<JobData>(context, listen: false).setQuery();
                  callbackFunc();
                }
                ),
                prefixIconColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color:Colors.white)
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 3.0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged:mySearch
            ),
        );
  }


  void mySearch(String query) {
    Provider.of<JobData>(context, listen: false).searchJob(query);
  }
}

