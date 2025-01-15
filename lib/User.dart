// import 'dart:convert' as convert;
//
// import 'package:http/http.dart' as http;
// import 'package:json_annotation/json_annotation.dart';
//
//  Future<Map<String, dynamic>> getPage() async{
//   var reponse = await http.get(
//       Uri.parse("https://api.nobelprize.org/2.1/nobelPrizes")
//   );
//   if (reponse.statusCode == 200) {
//     var jsonResponse =
//       convert.jsonDecode(reponse.body) as Map<String, dynamic>;
//     return jsonResponse;
//   }
//   else{
//   throw Exception('Failed to load album');
//   }
// }
//
// void main() async {
//   Map<String, dynamic> data = await getPage();
//   print("Données récupérées : $data");
// }
//
//
