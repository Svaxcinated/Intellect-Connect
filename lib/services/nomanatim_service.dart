import 'dart:convert';
import 'package:http/http.dart' as http;

class NominatimService {
  static Future<List<String>> fetchSuggestions(String input) async {
    final query = Uri.encodeComponent('$input Digos City Davao del Sur');
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');
    
    final response = await http.get(url, headers: {'User-Agent': 'YourAppName/1.0'});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((item) => item['display_name'] as String).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }
}