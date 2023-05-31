import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Job_data.dart';

class SearchJobs extends StatefulWidget {
  final Function closeCallBack;
  final Function searchCallBack;

  const SearchJobs({super.key, required this.closeCallBack, required this.searchCallBack});
  @override
  State<SearchJobs> createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  late Function closeCallBack;
  late Function searchCallBack;
  final _searchController = TextEditingController();
  void initState() {
    super.initState();
    closeCallBack=widget.closeCallBack;
    searchCallBack=widget.searchCallBack;
  }
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
              closeCallBack();
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
    searchCallBack(query);
  }
}

