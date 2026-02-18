import 'dart:convert';
import 'package:http/http.dart' as http;

class WikipediaApi {

  /// 🔹 Busca el resumen de un lugar en Wikipedia por nombre
  static Future<String?> getResumen(String nombreLugar) async {

    // 🔹 Limpia el nombre para usarlo en la búsqueda
    final query = Uri.encodeComponent(nombreLugar);

    final url =
        "https://es.wikipedia.org/api/rest_v1/page/summary/$query";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔹 extract solo devuelve el resumen limpio sin HTML
      final String? extract = data['extract'];

      if (extract != null && extract.isNotEmpty) {
        // 🔹 Limita a 600 caracteres para no saturar la pantalla
        return extract.length > 600
            ? '${extract.substring(0, 600)}…'
            : extract;
      }
    }

    return null; // Si no encuentra nada, retorna null
  }
}