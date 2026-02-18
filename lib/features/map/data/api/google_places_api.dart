import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesApi {

  static const String apiKey = "AIzaSyD_wPnI9Q3GH9JENdTqSAwOe_caaccUt84";

  static Future<Map<String, dynamic>?> getPlaceFromLatLng(
    double lat,
    double lng,
  ) async {
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

  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
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

  static String getPhotoUrl(String photoReference, {int maxWidth = 800}) {
    return "https://maps.googleapis.com/maps/api/place/photo"
        "?maxwidth=$maxWidth"
        "&photo_reference=$photoReference"
        "&key=$apiKey";
  }

  static List<String> buildPhotoUrls(List<String> references) {
    return references.map((ref) => getPhotoUrl(ref)).toList();
  }
}