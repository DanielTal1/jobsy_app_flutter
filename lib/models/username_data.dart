
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsernameData{

  //uses flutter_secure_storage to save username
  static Future<void> saveUsername(String username) async {
    final storage = FlutterSecureStorage();
    try {
      await storage.write(key: 'username', value: username);
      print('Username saved successfully');
    } catch (e) {
      print('Failed to save username: $e');
      // Handle the exception accordingly
    }
  }

  //retrieve the username from secure_storage
  static Future<String?> getUsername() async {
    final storage = FlutterSecureStorage();
    try {
      String? username = await storage.read(key: 'username');
      if (username==null){
        username="null";
      }
      print('Username retrieved successfully'+username);
      return username;
    } catch (e) {
      print('Failed to retrieve username: $e');
      // Handle the exception accordingly
      return null; // Return a default value or handle the error case
    }
  }

  //deletes the username from secure storage when logging out
  static Future<void> deleteUsernameData() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'username');
  }


  static Future<void> saveToken(String token) async {
    final storage = FlutterSecureStorage();
    try {
      await storage.write(key: 'token', value: token);
      print('Token saved successfully'+token);
    } catch (e) {
      print('Failed to save username: $e');
      // Handle the exception accordingly
    }
  }

  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    try {
      String? token = await storage.read(key: 'token');
      if (token==null){
        token="null";
      }
      print('Tokenravid retrieved successfully'+token);
      return token;
    } catch (e) {
      print('Failed to retrieve username: $e');
      // Handle the exception accordingly
      return null; // Return a default value or handle the error case
    }
  }



}