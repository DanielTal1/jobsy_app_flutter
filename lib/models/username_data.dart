
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsernameData{

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

  // Retrieve the username
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

}