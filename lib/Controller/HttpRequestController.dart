import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpRequestController {
  static Future<Map<String, dynamic>> getPage() async{
    var reponse = await http.get(
        Uri.parse("https://api.nobelprize.org/2.1/nobelPrizes")
    );
    if (reponse.statusCode == 200) {
      var jsonResponse =
      jsonDecode(reponse.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    else{
      throw Exception('Failed to load nobel');
    }
  }
}