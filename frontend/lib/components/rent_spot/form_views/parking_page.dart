import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parkme/api/request_handlers/rental_request.dart';
import 'package:parkme/app/navigator.dart';
import 'package:parkme/components/rent_spot/form_views/duration_picker.dart';
import 'package:parkme/components/rent_spot/form_views/license_plate_picker.dart';
import 'package:parkme/components/spot/spot.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/pages/homepage/homepage.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ParkingPage extends StatefulWidget {
  final Spot spot;
  final Function? onClick;

  const ParkingPage({Key? key, required this.spot, this.onClick})
      : super(key: key);

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  String? selectedLicensePlate;
  Duration selectedDuration = const Duration(hours: 1);
  late GoogleMapController mapController;
  num _totalPrice = 0.0;
  late LatLng _location;
  List<Marker> allMarkers = [];

  void _setLicensePlate(String value) {
    setState(() {
      selectedLicensePlate = value;
    });
  }

  num calcTotalPrice(Duration duration, num priceRate) {
    num totalPrice = duration.inHours * priceRate +
        ((duration.inMinutes % 60)) * priceRate / 60;
    totalPrice = roundDouble(totalPrice, 2);
    return totalPrice;
  }

  double roundDouble(num value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.spot.coords.lat, widget.spot.coords.long);
    _totalPrice = calcTotalPrice(selectedDuration, widget.spot.priceRate);
    allMarkers.add(
      Marker(
        markerId: const MarkerId('myMarker'),
        draggable: true,
        position: _location,
      ),
    );
  }

  late Duration test;
  void updateSelectedDuration(Duration duration) {
    setState(() {
      selectedDuration = duration;
      _totalPrice = calcTotalPrice(duration, widget.spot.priceRate);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(
        '[{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]}]');
  }

  MaterialBanner errorBanner(String text) {
    Future.delayed(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
    return MaterialBanner(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
      content: Column(
        children: [
          Text(text),
          // Image.asset(
          //   "assets/images/working.gif",
          //   height: 125.0,
          //   width: 125.0,
          // ),
        ],
      ),
      leading: const Icon(Icons.error),
      backgroundColor: Colors.red,
      actions: <Widget>[
        TextButton(
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          onPressed: () =>
              {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  Future<void> handleSubmit() async {
    if (selectedLicensePlate == null) {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      ScaffoldMessenger.of(context)
          .showMaterialBanner(errorBanner("Please select a license plate"));
      return;
    }
    final now = DateTime.now();
    final Object data = {
      "sid": widget.spot.id,
      "amount": _totalPrice,
      "start": now.toUtc().toIso8601String(),
      "end": now.add(selectedDuration).toUtc().toIso8601String(),
    };
    final res = await RentalRequest().rentSpot(data);
    if (!context.mounted) return;

    if (res.statusCode == 201) {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const TheHomePage(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => const App(),
      //     ));
    } else {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showMaterialBanner(errorBanner(
          "There was an error processing your request, please try again later."));

      print(res.statusCode);
      print(res.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Google map window
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _location,
                      zoom: 15,
                    ),
                    markers: <Marker>{
                      Marker(
                        markerId: const MarkerId('location'),
                        position: _location,
                      ),
                    },
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: _onMapCreated,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    myLocationEnabled: false,
                  ),
                ),
              ),
            ),
            const Divider(),
            // Duration Picker
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Duration: ${selectedDuration.inHours}h ${selectedDuration.inMinutes.remainder(60)}m',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DurationPickerModal(
                                  onDurationSelected: updateSelectedDuration,
                                  initialDuration: selectedDuration,
                                  endDuration: widget.spot.time.end
                                  // maxDuration: maxDuration,
                                  );
                            },
                          );
                        },
                        child: const Text('Select Duration',
                            style: TextStyle(
                              color: Colors.white,
                            ))),
                  )
                ],
              ),
            ),
            // License Plate Picker
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'License Plate',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  LicensePlateList(
                    onLicensePlateSelected: _setLicensePlate,
                  )
                ],
              ),
            ),
            const Divider(),
            // Total Price Displayer
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                  ),
                  Text(
                    'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => handleSubmit(),
                child: const Text(
                  'Start Renting',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
