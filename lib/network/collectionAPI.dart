import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/collectionsModels.dart';
class CollectionsService {
  static Future<CollectionsModel?> fetchCollections() async {
    final url = Uri.parse('https://admin.imboxo.com/api/movie-collection');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return CollectionsModel.fromJson(jsonBody);
      } else {
        print(
            'Failed to fetch collections. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching collections: $e');
      return null;
    }
  }
}