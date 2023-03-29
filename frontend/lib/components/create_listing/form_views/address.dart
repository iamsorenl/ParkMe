import 'package:flutter/material.dart';
import '../../../widgets/search_bar/index.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController address;
  final TextEditingController zip;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController country;

  final Function handleChange;

  const AddressForm({
    Key? key,
    required this.address,
    required this.zip,
    required this.city,
    required this.state,
    required this.country,
    required this.handleChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        SingleChildScrollView(
          child: Column (
            children: [
              Container(
                margin: const EdgeInsets.only(top: 80),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  enabled: false,
                  onChanged: (text) => {},
                  controller: address,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  enabled: false,
                  onChanged: (text) => {},
                  controller: city,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  enabled: false,
                  onChanged: (text) => {},
                  controller: state,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'State',
                  ),
                ),
              ), 
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  enabled: false,
                  onChanged: (text) => {},
                  controller: country,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Country',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  enabled: false,
                  onChanged: (text) => {},
                  controller: zip,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Zipcode',
                  ),
                ),
              ),
            ],
          ) 
        ),
         Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SearchBar(callback: handleChange),
         ),
      ],
    );
  }
}