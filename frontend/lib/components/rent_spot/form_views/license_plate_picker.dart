import 'package:flutter/material.dart';

class LicensePlateList extends StatefulWidget {
  final void Function(String licensePlate) onLicensePlateSelected;
  const LicensePlateList({Key? key, required this.onLicensePlateSelected})
      : super(key: key);

  @override
  State<LicensePlateList> createState() => _LicensePlateListState();
}

class _LicensePlateListState extends State<LicensePlateList> {
  List<String> _plates = [];
  // ['ABC 123', 'DEF 456', 'GHI 789'];
  String? _selectedPlate;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 140),
            child: ListView(shrinkWrap: true, children: [
              for (var plate in _plates)
                RadioListTile<String>(
                  title: Text(plate),
                  value: plate,
                  groupValue: _selectedPlate,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlate = value;
                      widget.onLicensePlateSelected(value!);
                    });
                  },
                ),
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add License Plate'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add License Plate'),
                    content: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter license plate',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final newPlate = _controller.text.trim();
                          if (newPlate.length >= 2 && newPlate.length <= 8) {
                            setState(() {
                              _plates.insert(0, newPlate);
                              _selectedPlate = newPlate;
                              widget.onLicensePlateSelected(newPlate);
                              _controller.clear();
                              Navigator.of(context).pop();
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Invalid License Plate'),
                                  content: const Text(
                                      'The license plate must be between 2 and 6 characters long.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _controller.clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Add'),
                      ),
                      TextButton(
                        onPressed: () {
                          _controller.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
