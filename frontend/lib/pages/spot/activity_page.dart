import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkme/components/spot/spot.dart';
import 'package:parkme/components/spot/spot_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/request_handlers/spot_request.dart';
import '../../api/request_handlers/rental_request.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late Future<List<Spot>> spots;

  @override
  void initState() {
    super.initState();
    spots = fetchRentalHistory();
  }

  void refreshRentalHistory() {
    setState(() {
      spots = fetchRentalHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rental History'),
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SpotList(data: spots),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: refreshRentalHistory,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.refresh),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}

Future<List<Spot>> fetchRentalHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final response = await RentalRequest()
      .getRented(prefs.getString('id')); // Use RentalRequest class
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Spot> spots = List<Spot>.from(data.map((spot) => jsonToSpot(spot)));
    return spots;
  } else {
    throw Exception('Failed to fetch data');
  }
}
