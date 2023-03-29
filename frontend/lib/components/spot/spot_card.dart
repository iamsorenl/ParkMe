import 'package:flutter/material.dart';
import 'package:parkme/components/spot/spot.dart';
import 'package:intl/intl.dart';

// class SpotData {
//   late String description;
//  late Stirn
// }

class SpotCard extends StatelessWidget {
  final Spot spot;
  final Function? onClick;

  const SpotCard({Key? key, required this.spot, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick != null ? onClick!(spot) : {},
      child: Card(
        elevation: 5,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    spot.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(spot.priceRate.toString()),
                  const SizedBox(height: 10),
                  Text(spot.address.addr),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(DateFormat('MMMM d, y').format(spot.time.start)),
                      const Text(", "),
                      Text(
                          '${DateFormat.jm().format(spot.time.start)} - ${DateFormat.jm().format(spot.time.end)}'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
