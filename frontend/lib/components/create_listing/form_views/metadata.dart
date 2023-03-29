import 'package:flutter/material.dart';
import './media_form.dart';

class MetadataForm extends StatelessWidget {
  final TextEditingController price;
  final TextEditingController desc;
  final TextEditingController name;
  final Function handleChange;
  final Function handleSubmit;
  final Function imageSelect;

  const MetadataForm({
    Key? key,
    required this.price,
    required this.desc,
    required this.name,
    required this.handleChange,
    required this.handleSubmit,
    required this.imageSelect,
  }) : super (key: key);

  @override

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column (
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container (
            padding: const EdgeInsets.all(10),
            child: const Text('Add additional information')
          ),
          Container (
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              onChanged: (text) => handleChange(),
              controller: name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('name'),
              ),
            ),
          ),
          Container (
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              maxLines: 8,
              onChanged: (text) => handleChange(),
              controller: desc,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('describe the spot'),
              ),
            ),
          ),

          Container (
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              onChanged: (text) => handleChange(),
              controller: price,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Price rate \$/hr'),
              ),
            ),
          ),
          Container (
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Add visual content?"),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MediaForm(imageSelect: imageSelect)),
                    );
                  },
                  icon: const Icon(Icons.add_box),
                ),
                ]
              ),
            ),
          /*Container (
            height: 50,
            width: 100,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: const MediaSelector(title: 'Image Picker Example'),
          ),*/
          const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded (
                    child:  Container(
                      height: 55,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('submit'),
                        onPressed: () => handleSubmit(),
                      )
                    ),
                  ),
                ]
              ),
        ],
      ),
    );
  }
}