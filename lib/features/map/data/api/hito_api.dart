import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hito.dart';

class HitoApi {
  static const baseUrl = "http://127.0.0.1:3000/api/hitos";

  static Future<List<Hito>> getHitos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((e) => Hito.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Error cargando hitos');
  }
}
