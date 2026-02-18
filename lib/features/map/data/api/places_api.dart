import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesApi {
  // ⚠️ PON TU API KEY AQUÍ
  static const String apiKey = "AIzaSyD_wPnI9Q3GH9JENdTqSAwOe_caaccUt84";

  /// 🔥 BUSCA LUGAR CERCANO
  static Future<dynamic> getPlaceFromLatLng(double lat, double lng) async {
    final nearbyUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=$lat,$lng"
        "&radius=50"
        "&key=$apiKey";

    final nearbyResponse = await http.get(Uri.parse(nearbyUrl));

    if (nearbyResponse.statusCode != 200) return null;

    final nearbyData = jsonDecode(nearbyResponse.body);

    // ignore: avoid_dynamic_calls
    if ((nearbyData['results'] as List).isEmpty) return null;

    final placeId = nearbyData["results"][0]["place_id"];

    /// 🔥 AHORA TRAEMOS DETALLES
    final detailUrl =
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&fields=name,formatted_address,rating,photos"
        "&key=$apiKey";

    final detailResponse = await http.get(Uri.parse(detailUrl));

    if (detailResponse.statusCode != 200) return null;

    final detailData = jsonDecode(detailResponse.body);

    return detailData["result"];
  }

  /// 🔥 CONSTRUIR URL FOTO
  static String getPhotoUrl(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo"
        "?maxwidth=800"
        "&photo_reference=$photoReference"
        "&key=$apiKey";
  }
}
