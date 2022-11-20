import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../main.dart';

class HttpRequest {
  static Future<dynamic> getData(String slug) async {
    var url = 'https://api-football-v1.p.rapidapi.com/v3/$slug';
    var response = await http.get(Uri.parse(url), headers: headers);
    try {
      if (response.statusCode == 200) {
        return json.decode(response.body)['response'];
      } else {
        return "failed";
      }
    } catch (exp) {
      return "failed";
    }
  }
}
