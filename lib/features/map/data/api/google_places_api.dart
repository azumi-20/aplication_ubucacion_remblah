import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesApi {

  static const String apiKey = "AIzaSyD_wPnI9Q3GH9JENdTqSAwOe_caaccUt84";

  /// 🔹 Buscar lugar cercano al tocar el mapa
  static Future<Map<String, dynamic>?> getPlaceFromLatLng(
      double lat, double lng) async {

    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=$lat,$lng"
        "&radius=60"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["results"] != null && data["results"].isNotEmpty) {
        return data["results"][0];
      }
    }

    return null;
  }

  /// 🔹 Obtener detalles completos — 🆕 campos actualizados
  static Future<Map<String, dynamic>?> getPlaceDetails(
      String placeId) async {

    // 🆕 Ahora pide todos los campos nuevos del modelo
    final fields = [
  'place_id',
  'name',
  'vicinity',
  'formatted_address',
  'geometry',
  'types',
  'photos',
  'business_status',
  'url',
  'wheelchair_accessible_entrance',
  'icon',
].join(',');

    final url =
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&fields=$fields"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["result"];
    }

    return null;
  }

  /// 🔹 Construye la URL de una foto individual
  static String getPhotoUrl(String photoReference, {int maxWidth = 800}) {
    return "https://maps.googleapis.com/maps/api/place/photo"
        "?maxwidth=$maxWidth"
        "&photo_reference=$photoReference"
        "&key=$apiKey";
  }

  // 🆕 Construye la lista completa de URLs de fotos de un hito
  static List<String> buildPhotoUrls(List<String> references) {
    return references
        .map((ref) => getPhotoUrl(ref))
        .toList();
  }
}