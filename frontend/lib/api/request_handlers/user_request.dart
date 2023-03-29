import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRequest {
  Future<http.Response> getUser(authToken, id) async {
    if (id.length > 0) {
      // ignore: prefer_interpolation_to_compose_strings
      id = '/' + id;
    } else {
      id = '';
    }
    final URI = Uri.http('${dotenv.env['host']}:3000', "user$id");
    print(URI);
    return http.get(
      URI,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );
  }

  Future<http.Response> editUser(authToken, id, data) async {
    return http.put(
      Uri.http(
        "${dotenv.env['host']}:3000",
        "user/$id"
      ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data),
    );
  }
  Future<http.Response> uploadPhoto(authToken, file) async {
    var request = http.MultipartRequest('POST', Uri.http("${dotenv.env['host']}:3000", 'upload'))
      ..headers['Authorization'] = 'Bearer $authToken';
      request.files.add(http.MultipartFile.fromBytes(
          'files', file.readAsBytesSync(),
          filename: const Uuid().v4()));

    var response = await request.send();
    return http.Response.fromStream(response);
  }
}

