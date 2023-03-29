import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkme/app/persisten_nav_padding.dart';
import 'package:parkme/components/address_autocomplete/models/autocomplate_prediction.dart';
import 'package:parkme/components/address_autocomplete/components/location_list_tile.dart';
import 'package:parkme/components/address_autocomplete/components/address_functions.dart';
import '../../components/create_listing/form_views/schedule.dart';
import '../../components/google_map/components/map_functions.dart';
import '../../widgets/buttons/logout_button.dart';

class TheHomePage extends StatefulWidget {
  const TheHomePage({super.key});

  @override
  State<TheHomePage> createState() => _TheHomePageState();
}

class _TheHomePageState extends State<TheHomePage> {
  // prediction to use on submission by user
  int _selectedPredictionIndex = 0;

  // markers for map
  final Map<String, Marker> markers = {};

  // boolean for drawer toggle
  bool _isDrawerOpen = false;

  // list for location predictions
  List<AutocompletePrediction> placePredictions = [];

  // list for placeId's
  List<String?> placeIds = [];

  // controller for search bar text
  TextEditingController searchBarController = TextEditingController();

  // boolean for showing place predictions
  bool _showPredictions = false;

  // lat and long to deafult over Santa Cruz
  double lat = 36.974117;
  double long = -122.030792;

  // distance value set by slider
  double _distance = 10.0;

  // google maps controller
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  // date and time objects to be placed in drawer
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  // error text
  String errorText = "";

  void handleFieldInput() {
    setState(() {
      errorText = "";
    });
  }

  void changeDate(DateTime newDate) {
    return setState(() {
      date = newDate;
    });
  }

  void selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (newTime != null) {
      setState(() {
        startTime = newTime;
      });
    }
    //print(startTime);
  }

  void selectEndTime() async {
    final TimeOfDay? newEndTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (newEndTime != null) {
      setState(() {
        endTime = newEndTime;
      });
    }
    //print(endTime);
  }

  // height of the drawer
  double _drawerHeight = 0;

  void onSearchBarTyped(String query) async {
    List<AutocompletePrediction> placePredictions =
        await placeAutocompletePredictionsList(query);

    List<String> placeIds = await placeAutocompletePlaceIds(query);
    if (placePredictions.isNotEmpty) {
      setState(() {
        this.placePredictions = placePredictions;
        this.placeIds = placeIds;
      });
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    //print("lat: $lat, long: $long");
    await placePins(
      controller: controller,
      markers: markers,
      setState: setState,
      context: context,
      date: date,
      distance: _distance,
      origin: LatLng(lat, long),
    );
  }

  Future<void> refreshMap() async {
    final GoogleMapController controller = await _controllerCompleter.future;
    markers.clear(); // remove existing markers
    //print("lat: $lat, long: $long");
    // ignore: use_build_context_synchronously
    await placePins(
      controller: controller,
      markers: markers,
      setState: setState,
      context: context,
      date: date,
      distance: _distance,
      origin: LatLng(lat, long),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('back button for debug'),
        //   automaticallyImplyLeading: true,
        // ),
        body: Column(
      children: [
        Container(
          height: statusBarHeight,
          color: Colors.blue,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // color: Colors.blue,
                  child: TextField(
                    controller: searchBarController,
                    onChanged: (value) {
                      onSearchBarTyped(value);
                      if (value.isNotEmpty) {
                        setState(() {
                          _showPredictions = true;
                        });
                      } else {
                        setState(() {
                          _showPredictions = false;
                        });
                      }
                    },
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        lat = await getLat(value, _selectedPredictionIndex);
                        long = await getLng(value, _selectedPredictionIndex);
                        final GoogleMapController controller =
                            await _controllerCompleter.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: LatLng(lat, long), zoom: 13),
                          ),
                        );
                        _showPredictions = false;
                        await refreshMap();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Destination',
                      prefixIcon: const Icon(Icons.search),
                      // contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDrawerOpen = !_isDrawerOpen;
                  });
                },
                child: const Icon(Icons.menu),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  onMapCreated(controller);
                  _controllerCompleter.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 12,
                ),
                markers: markers.values.toSet(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: _showPredictions && !_isDrawerOpen,
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                        press: () {
                          final String selectedPrediction =
                              placePredictions[index].description!;
                          final String newText = selectedPrediction;
                          searchBarController.value = TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                                offset: selectedPrediction.length),
                          );
                          setState(() {
                            _showPredictions = false;
                          });
                          _selectedPredictionIndex = index;
                        },
                        location: placePredictions[index].description!,
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: AnimatedContainer(
                  height: _isDrawerOpen ? 150 : 0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  onEnd: () {
                    setState(() {
                      _drawerHeight = _isDrawerOpen ? 150 : 0;
                    });
                  },
                  child: ClipRect(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 2.0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          if (_drawerHeight == 150 && _isDrawerOpen)
                            Positioned(
                              bottom: 10, // adjust the position as needed
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  const Text('Spot distance from destination'),
                                  Slider(
                                    value: _distance,
                                    min: 1.0,
                                    max: 20.0,
                                    onChanged: (value) {
                                      setState(() {
                                        _distance = value;
                                      });
                                    },
                                    label: '${_distance.round()} miles',
                                    divisions: 100,
                                  ),
                                  ApplyChangesButton(
                                    onPressed: () {
                                      setState(() {
                                        _isDrawerOpen = false;
                                        _drawerHeight = 0;
                                      });
                                      refreshMap();
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10, // adjust the position as needed
                right: 10,
                child: FloatingActionButton(
                  onPressed: refreshMap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blue,
                  child: const Text(
                    'Refresh',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const PersistentNavPadding()
      ],
    ));
  }
}
