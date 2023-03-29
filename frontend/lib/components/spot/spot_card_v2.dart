import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkme/components/spot/spot.dart';

class SpotCardV2 extends StatefulWidget {
  final Spot spot;
  final Function? onClick;

  SpotCardV2({Key? key, required this.spot, this.onClick}) : super(key: key);

  @override
  State<SpotCardV2> createState() => _SpotCardV2State();
}

class _SpotCardV2State extends State<SpotCardV2> {
  final formatter = DateFormat('MMM d, yyyy h:mm a');

  late String startFormatted;

  late String endFormatted;

  late String start = widget.spot.time.start.toIso8601String();
  late String end = widget.spot.time.end.toIso8601String();

  @override
  void initState() {
    super.initState();
    startFormatted = formatter.format(widget.spot.time.start);
    endFormatted = formatter.format(widget.spot.time.end);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClick != null ? widget.onClick!(widget.spot) : {},
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                widget.spot.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                widget.spot.address.addr,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                  '${widget.spot.address.locality}, ${widget.spot.address.region} ${widget.spot.address.zipcode}'),
              leading: Icon(
                CupertinoIcons.location_circle,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: const Text("Availability"),
              subtitle: Text('$startFormatted - $endFormatted'),
              leading: Icon(
                CupertinoIcons.calendar,
                color: Colors.blue[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
