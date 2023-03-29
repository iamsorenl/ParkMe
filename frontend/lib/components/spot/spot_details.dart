import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkme/components/rent_spot/index.dart';
import 'package:parkme/components/spot/spot.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/request_handlers/spot_request.dart';

class SpotDetails extends StatefulWidget {
  final Spot spot;
  const SpotDetails({Key? key, required this.spot}) : super(key: key);

  @override
  State<SpotDetails> createState() => _SpotDetailsState();
}

class _SpotDetailsState extends State<SpotDetails> {
  bool available = false;
  @override
  void initState() {
    super.initState();
    fetchAvailableSpot();
  }

  void fetchAvailableSpot() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    final queryParameters = {
      'start': DateTime.now().toUtc().toIso8601String(),
      'end': DateTime.now().toUtc().toIso8601String(),
      'id': widget.spot.id
    };
    final response =
        await SpotRequest().getAllAvailableSpots(authToken, queryParameters);
    // check to see if user owns the spot
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.length > 0) {
        //print(data);
        setState(() {
          available = true;
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
    // Check if user owns the spot
    final ownedSpotsResponse = await SpotRequest().getPostedSpots(authToken);
    if (ownedSpotsResponse.statusCode == 200) {
      final ownedSpotsData = json.decode(ownedSpotsResponse.body);
      final userOwnsSpot =
          ownedSpotsData.any((spot) => spot["id"] == widget.spot.id);
      //print("User owns the spot: $userOwnsSpot");

      // Set available to false if user owns the spot
      if (userOwnsSpot) {
        setState(() {
          available = false;
        });
      }
    } else {
      throw Exception('Failed to fetch owned spots data');
    }
  }

  @override
  void dispose() {
    available = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('start for ${widget.spot.name} ${widget.spot.time.start}');
    return IntrinsicHeight(
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.spot.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            subtitle: Text(widget.spot.description),
          ),
          ListTile(
            title: Text(
              available ? "Available" : "Currently Unavailable",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: available
                ? Icon(
                    CupertinoIcons.check_mark_circled,
                    color: Colors.green[400],
                  )
                : Icon(
                    CupertinoIcons.clear_circled,
                    color: Colors.red[400],
                  ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              widget.spot.address.addr,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
                '${widget.spot.address.locality}, ${widget.spot.address.region} ${widget.spot.address.zipcode}'),
            leading: Icon(
              CupertinoIcons.location_circle,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(
              '\$${widget.spot.priceRate}/hour',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              CupertinoIcons.money_dollar_circle,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text(DateFormat('MMMM d, y').format(widget.spot.time.start)),
            leading: Icon(
              CupertinoIcons.calendar,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: const Text("Availability"),
            subtitle: Text(
                '${DateFormat.jm().format(widget.spot.time.start)} - ${DateFormat.jm().format(widget.spot.time.end)}'),
            leading: Icon(
              CupertinoIcons.time,
              color: Colors.blue[500],
            ),
          ),
          // const SizedBox(height: 100),
          available
              ? Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                            child: const Text('Rent Spot'),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RentalPage(spot: widget.spot),
                                    fullscreenDialog: false)))),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
