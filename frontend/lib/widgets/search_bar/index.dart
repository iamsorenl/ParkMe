import 'package:flutter/material.dart';
import 'package:parkme/components/address_autocomplete/models/autocomplate_prediction.dart';
import 'package:parkme/components/address_autocomplete/components/address_functions.dart';

import '../../components/address_autocomplete/components/location_list_tile.dart';
class SearchBar extends StatefulWidget {
  final Function callback;
  const SearchBar({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBar();
  
}

class _SearchBar extends State<SearchBar> {
  TextEditingController searchBarController = TextEditingController();
  List<AutocompletePrediction> placePredictions = [];
  List<String?> placeIds = [];
  bool _showPredictions = false;
  int _selectedPredictionIndex = 0;

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row (
          children: [
            Expanded(
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
                    widget.callback(value, placeIds[_selectedPredictionIndex]);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search Destination',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _showPredictions,
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTile(
                press: () {
                  widget.callback('', placeIds[index]);
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
      ]
    );
  }

}