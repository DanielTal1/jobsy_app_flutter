

import 'package:url_launcher/url_launcher.dart';

class UrlData{

  static  Future<void> launchUrlFun(url_string,context) async {
    final Uri url = Uri.parse(url_string);
    if (!await launchUrl(url,mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }



}