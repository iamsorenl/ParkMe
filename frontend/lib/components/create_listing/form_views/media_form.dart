import 'package:flutter/material.dart';
import '../../../widgets/image_picker/index.dart';

class MediaForm extends StatelessWidget {
  final Function imageSelect;
  const MediaForm({
    Key? key,
    required this.imageSelect,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: MediaSelector(title: 'Add some pictures of your parking spot', callBack: imageSelect),
      bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded (
              child:  Container(
                height: 80,
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  child: const Text('done'),
                  onPressed: () {
                    Navigator.pop(context);
                  }
                )
              ),
            ),
          ]
        )
    );
  }
}
