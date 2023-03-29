import 'package:parkme/api/request_handlers/spot_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parkme/components/spot/spot.dart';
import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:parkme/components/spot/spot.dart';
// import 'package:parkme/components/spot/spot_list.dart';

// class AvailableSpotsPage extends StatefulWidget {
//   const AvailableSpotsPage({Key? key}) : super(key: key);
//   @override
//   State<AvailableSpotsPage> createState() => _AvailableSpotsPageState();
// }

// class _AvailableSpotsPageState extends State<AvailableSpotsPage> {
//   // Create instance variables to hold the selected start and end times
//   TimeOfDay startTime = TimeOfDay.now();
//   TimeOfDay endTime = TimeOfDay.now();
//   late Future<List<Spot>> spots;
//   @override
//   void initState() {
//     super.initState();

//     spots = fetchAllSpots(startTime, endTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: const Text('ParkMe'),
//       ),
//       body: SpotList(
//         data: spots,
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: SizedBox(
//           height: 50.0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () async {
//                   final TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       startTime = pickedTime;
//                     });
//                   }
//                 },
//                 child: Text(
//                   'Start Time: ${startTime?.format(context) ?? "Select"}',
//                 ),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   final TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       endTime = pickedTime;
//                     });
//                   }
//                 },
//                 child: Text(
//                   'End Time: ${endTime?.format(context) ?? "Select"}',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // if (startTime != null && endTime != null) {
//             final now =  DateTime.now();
//             final List<dynamic> availableSpots =
//                 await fetchAllSpots(
//           DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute),
//           DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute)
//                   );
//             // Do something with the availableSpots data
//           // } else {
//           //   showDialog(
//           //     context: context,
//           //     builder: (BuildContext context) {
//           //       return AlertDialog(
//           //         title: const Text('Error'),
//           //         content: const Text('Please select a start and end time.'),
//           //         actions: <Widget>[
//           //           TextButton(
//           //             child: const Text('OK'),
//           //             onPressed: () {
//           //               Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }

// Future<List<Spot>> fetchAllSpots(DateTime start, DateTime end) async {
//   final startDateTime =
//       DateTime(now.year, now.month, now.day, start.hour, start.minute);
//   final endDateTime =
//       DateTime(now.year, now.month, now.day, end.hour, end.minute);

//   final prefs = await SharedPreferences.getInstance();
//   final authToken = prefs.getString('token');
//   final queryParameters = {
//     'start': startDateTime.toIso8601String(),
//     'end': endDateTime.toIso8601String(),
//   };
//   final response =
//       await SpotRequest().getAllAvailableSpots(authToken, queryParameters);
//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     throw Exception('Failed to fetch data');
//   }
// }

Future<List<Spot>> fetchAllSpots(DateTime start, DateTime end) async {
  // Obtain an instance of SharedPreferences to retrieve authentication token

  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('token');
  // Create a map of query parameters to send with the GET request

  final queryParameters = {
    'start': start.toUtc().toIso8601String(),
    'end': end.toUtc().toIso8601String(),
  };
  // Send a GET request to retrieve all available spots

  final response =
      await SpotRequest().getAllAvailableSpots(authToken, queryParameters);
  if (response.statusCode == 200) {
    // If the response is successful, parse the JSON data into a list of Spot objects

    final data = json.decode(response.body);
    List<Spot> spots = List<Spot>.from(data.map((spot) => jsonToSpot(spot)));
    return spots;
  } else {
    // If the response is not successful, throw an exception

    throw Exception('Failed to fetch data');
  }
}

// A function to fetch all spots
Future<List<Spot>> obtainAllSpots() async {
  // Obtain an instance of SharedPreferences to retrieve authentication token

  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('token');
  // Send a GET request to retrieve all spots

  final response = await SpotRequest().getAllSpots(authToken);
  if (response.statusCode == 200) {
    // If the response is successful, parse the JSON data into a list of Spot objects

    final data = json.decode(response.body);
    // print("this is data");
    //print(data);
    List<Spot> spots = List<Spot>.from(data.map((spot) => jsonToSpot(spot)));
    return spots;
  } else {
    // If the response is not successful, throw an exception

    throw Exception('Failed to fetch data');
  }
}
