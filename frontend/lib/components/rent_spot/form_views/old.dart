// import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:parkme/components/rent_spot/form_views/license_plate_picker.dart';
// import 'package:parkme/components/spot/spot.dart';
// import 'dart:math';

// class DurationSelector extends StatefulWidget {
//   final Spot spot;
//   const DurationSelector({Key? key, required this.spot}) : super(key: key);

//   @override
//   State<DurationSelector> createState() => _DurationSelectorState();
// }

// class _DurationSelectorState extends State<DurationSelector> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   availableDuration =
//   //       calcAvailableDuration(DateTime.now(), widget.spot.time.end);
//   //   availableHoursAndMinutes =
//   //       calcAvailableHoursAndMinutes(availableDuration, 0);
//   //   _totalPrice = calcTotalPrice(_time, widget.spot.priceRate);
//   // }

//   MaterialBanner errorBanner(String text) {
//     Future.delayed(const Duration(seconds: 3), () {
//       ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
//     });
//     return MaterialBanner(
//       padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
//       content: Text(text),
//       leading: const Icon(Icons.error),
//       backgroundColor: Colors.red,
//       actions: <Widget>[
//         TextButton(
//           style: const ButtonStyle(
//             foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
//           ),
//           onPressed: () =>
//               {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
//           child: const Text('Dismiss'),
//         ),
//       ],
//     );
//   }

//   bool iosStyle = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 // mainAxisAlignment: Alignment.center,
//                 children: <Widget>[
//                   // Text(DateTime.now().toIso8601String()),
//                   // SizedBox(
//                   //   width: 300,
//                   //   child: DurationPicker(
//                   //     endTime: widget.spot.time.end,
//                   //     onDurationChanged: (Duration duration) {
//                   //       // handle duration changed
//                   //       print(duration);
//                   //     },
//                   //   ),
//                   // ),
//                   const SizedBox(height: 20),

//                   // Text(
//                   //   'Price Rate: \$${widget.spot.priceRate}',
//                   //   style: Theme.of(context).textTheme.titleLarge,
//                   // ),
//                   Text(
//                     'Select a License Plate',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 10),
//                   const SizedBox(width: 360, child: LicensePlateList()),
//                   const SizedBox(height: 10),
//                   // Text(
//                   //   'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
//                   //   style: Theme.of(context).textTheme.titleLarge,
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: Padding(
//       //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
//       //   child: Container(
//       //       height: 50,
//       //       padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
//       //       child: ElevatedButton(
//       //           child: const Text('Start Parking'),
//       //           onPressed: () => {
//       //                 // sendRentRequest();
//       //                 // ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
//       //                 // ScaffoldMessenger.of(context).showMaterialBanner(
//       //                 //     errorBanner(
//       //                 //         "An error occurred, please Try again later."))
//       //               }
//       //           // Navigator.push(
//       //           // context,
//       //           // MaterialPageRoute(
//       //           //     builder: (BuildContext context) => const CreateSpotPage(),
//       //           //     fullscreenDialog: true
//       //           )),
//       // ),
//     );
//   }
// }

// double calcTotalPrice(Time duration, num priceRate) {
//   double totalPrice =
//       duration.hour * priceRate + (duration.minute / 60) * priceRate;
//   totalPrice = roundDouble(totalPrice, 2);
//   return totalPrice;
// }

// double roundDouble(double value, int places) {
//   num mod = pow(10.0, places);
//   return ((value * mod).round().toDouble() / mod);
// }
