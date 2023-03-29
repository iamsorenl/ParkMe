import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SpotRequest {
  final baseUrl = '${dotenv.env['host']}:3000';
  Future<http.Response> getAllAvailableSpots(authToken, queryParameters) async {
    return await http.get(
      Uri.http(baseUrl, "spot/available", queryParameters),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );
  }

  Future<http.Response> getPostedSpots(authToken) async {
    return await http.get(
      Uri.http(baseUrl, "spot/owned"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );
  }

  Future<http.Response> createUtil(authToken, data) async {
    return http.post(Uri.http(baseUrl, "spot"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data));
  }

  Future<http.Response> createSpot(authToken, data, List<XFile> files) async {
    /*
      Since we have nested json it's best to split this request into two parts
      SEE: https://stackoverflow.com/questions/4083702/posting-a-file-and-associated-data-to-a-restful-webservice-preferably-as-json
    */
    if (files.isNotEmpty) {
      var request = http.MultipartRequest('POST', Uri.http(baseUrl, 'upload'))
        ..headers['Authorization'] = 'Bearer $authToken';
      for (int i = 0; i < files.length; ++i) {
        File file = File(files[0].path);
        request.files.add(http.MultipartFile.fromBytes(
            'files', file.readAsBytesSync(),
            filename: const Uuid().v4()));
      }
      var response = await request.send();
      var httpResponse = await http.Response.fromStream(response);
      var responseBody = json.decode(httpResponse.body);
      print('response from multipart');
      print(httpResponse.statusCode);
      print('response body');
      print(responseBody);
      if (httpResponse.statusCode != 200)
        throw Exception('unable to process request');
      data["pictures"] = responseBody;
    }
    return createUtil(authToken, data);
    // check if response
  }

  Future<http.Response> getAllSpots(authToken) async {
    return await http.get(
      Uri.http(baseUrl, "spot"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );
  }
}
