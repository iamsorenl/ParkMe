import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkme/components/address_autocomplete/components/constants.dart';
import 'package:parkme/components/address_autocomplete/components/network_utility.dart';
import 'package:parkme/components/address_autocomplete/models/autocomplate_prediction.dart';
import 'package:parkme/components/address_autocomplete/models/place_auto_complate_response.dart';

dynamic parseAddressComponent(data) {
  dynamic relation = {
    "street_number": "addr",
    "route": "addr",
    "locality": "locality",
    "administrative_area_level_1": "region",
    "postal_code": "zipcode",
    "country": "country",

  };
  dynamic address = {
    "addr": "",
    "locality": "",
    "region": "",
    "zipcode": "",
    "country": "",
  };
  for (dynamic item in data) {
    relation.forEach((k, v) => {
      if (item["types"].contains(k)) {
        address[v] = [address[v], item["long_name"]].join(' ')
      }
    });
  }
  return address;
}

Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
  final response = await http.get(Uri.https(
    'maps.googleapis.com',
    '/maps/api/place/details/json',
    {
      'place_id': placeId,
      'fields': 'geometry,address_components',
  
      'key': apiKey,
    },
  ));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['result'];
  } else {
    throw Exception('Failed to load place details');
  }
}

Future<double> getLat(String address, int num) async {
  List<String> placeIds = await placeAutocompletePlaceIds(address);
  final placeDetails = await getPlaceDetails(placeIds[num]);
  final locationA = placeDetails['geometry']['location'];
  return locationA['lat'];
}

Future<double> getLng(String address, int num) async {
  List<String> placeIds = await placeAutocompletePlaceIds(address);
  final placeDetails = await getPlaceDetails(placeIds[num]);
  final locationA = placeDetails['geometry']['location'];
  return locationA['lng'];
}

Future<List<AutocompletePrediction>> placeAutocompletePredictionsList(
    String query) async {
  List<AutocompletePrediction> placePredictions = [];
  Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json', // unencoder path
      {
        "input": query, // query parameter
        "key": apiKey, // make sure you add your api key
      });
  // its time to make the GET request
  String? response = await NetworkUtility.fetchUrl(uri);

  if (response != null) {
    PlaceAutocompleteResponse result =
        PlaceAutocompleteResponse.parseAutocompleteResult(response);
    if (result.predictions != null) {
      placePredictions = result.predictions!;
    }
  }

  return placePredictions;
}

Future<List<String>> placeAutocompletePlaceIds(String query) async {
  List<AutocompletePrediction> placePredictions =
      await placeAutocompletePredictionsList(query);
  List<String>? placeIds = [];

  if (placePredictions.isNotEmpty) {
    placeIds = placePredictions
        .map((prediction) => prediction.placeId)
        .cast<String>()
        .toList();
  }

  return placeIds;
}
