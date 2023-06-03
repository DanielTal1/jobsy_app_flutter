
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsy_app_flutter/models/recommendation.dart';
import 'dart:convert';


class RecommendationData extends ChangeNotifier{
  List<Recommendation> _recommendation = [];
  bool _isLoading = false;
  List<Recommendation> get recommendations => _recommendation;
  bool get isLoading => _isLoading;

  RecommendationData() {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/recommendation/tuna'));
      final jsonData = json.decode(response.body) as List<dynamic>;
      _recommendation = jsonData.map((recommendationData) => Recommendation.fromJson(recommendationData)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw error;
    }
  }


}