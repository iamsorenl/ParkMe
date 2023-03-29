import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkme/components/spot/spot.dart';
import 'package:parkme/components/spot/spot_list.dart';
import 'package:parkme/pages/spot/view_spot_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/request_handlers/spot_request.dart';

class PostedSpots extends StatefulWidget {
  const PostedSpots({Key? key}) : super(key: key);

  @override
  State<PostedSpots> createState() => _PostedSpotsState();
}

class _PostedSpotsState extends State<PostedSpots> {
  late Future<List<Spot>> spots;

  @override
  void initState() {
    super.initState();
    spots = fetchPostedSpots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posted Spots'),
        ),
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SpotList(
                  data: spots,
                  onClick: (Spot spot) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ViewSpotPage(
                          spot: spot,
                        ),
                      )))),
        ),
      ),
    );
  }
}

Future<List<Spot>> fetchPostedSpots() async {
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('token');
  final response = await SpotRequest().getPostedSpots(authToken);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Spot> spots = List<Spot>.from(data.map((spot) => jsonToSpot(spot)));
    return spots;
  } else {
    throw Exception('Failed to fetch data');
  }
}
