import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/app/persisten_nav_padding.dart';
import 'package:parkme/components/spot/spot_details.dart';
import 'package:parkme/pages/available_spots/available_spots_page.dart';

Future<void> placePins({
  required GoogleMapController controller,
  required Map<String, Marker> markers,
  required Function setState,
  required BuildContext context,
  required DateTime date,
  required double distance,
  required LatLng origin,
}) async {
  final parkingSpots = await obtainAllSpots();
  final newMarkers = <String, Marker>{};
  Marker marker = Marker(
    markerId: const MarkerId("Destination"),
    position: origin,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    infoWindow: const InfoWindow(
      title: "Destination",
    ),
  );
  newMarkers["Destination"] = marker;
  //print(parkingSpots.length);
  for (final spot in parkingSpots) {
    LatLng latLngSpot = LatLng(
      spot.coords.lat.toDouble(),
      spot.coords.long.toDouble(),
    );
    double calculatedDistance = calculateDistance(origin, latLngSpot);
    //print('calculated distance: $calculatedDistance');
    if (calculatedDistance <= distance) {
      marker = Marker(
        markerId: MarkerId(spot.address.addr),
        position: LatLng(
          spot.coords.lat.toDouble(),
          spot.coords.long.toDouble(),
        ),
        infoWindow: InfoWindow(
          title: spot.name,
          snippet: spot.address.addr,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SpotDetails(spot: spot),
                      const PersistentNavPadding(),
                      const SizedBox(height: 5)
                      // Expanded(child: Container()), // Add Expanded here
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
      newMarkers[spot.address.addr] = marker;
    }
  }
  setState(() {
    markers.clear();
    markers.addAll(newMarkers);
  });
}

// builds date time type from DateTime and given date
DateTime buildDateTime(time, date) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

// calculate distance between coordinates
const double earthRadius = 3958.8; // in miles
double calculateDistance(LatLng start, LatLng end) {
  double lat1 = start.latitude;
  double lon1 = start.longitude;
  double lat2 = end.latitude;
  double lon2 = end.longitude;

  double dLat = radians(lat2 - lat1);
  double dLon = radians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(radians(lat1)) * cos(radians(lat2)) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;
  return distance;
}

double radians(double degrees) {
  return degrees * pi / 180;
}


