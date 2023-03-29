import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parkme/api/request_handlers/local_storage.dart';

class RentalRequest {
  final baseUrl = '${dotenv.env['host']}:3000';
  Future<http.Response> rentSpot(data) async {
    final authToken = await LocalStorage().getAuthToken();
    return await http.post(Uri.http(baseUrl, "rental"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data));
  }

  Future<http.Response> getRented(id) async {
    final authToken = await LocalStorage().getAuthToken();
    return await http.get(Uri.http(baseUrl, "rental/$id"), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken',
    });
  }
}
