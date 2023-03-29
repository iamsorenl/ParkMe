import 'package:flutter/material.dart';
import 'package:parkme/components/spot/spot.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ViewSpotPage extends StatefulWidget {
  final Spot spot;
  const ViewSpotPage({Key? key, required this.spot}) : super(key: key);

  @override
  State<ViewSpotPage> createState() => _ViewSpotPage();
}

class _ViewSpotPage extends State<ViewSpotPage> {
  late Future<List<Spot>> spots;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Details'),
      ),
      body: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.spot.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              // subtitle: const Text('My City, CA 99984'),
              // ignore: prefer_const_constructors
              // leading: Icon(
              //     // Icons.restaurant_menu,
              //     // color: Colors.blue[500],
              //     ),
            ),
            const Divider(),
            ListTile(subtitle: Text(widget.spot.description)),
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
              title: Text(
                '\$${widget.spot.priceRate}/hour',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(
                CupertinoIcons.money_dollar_circle,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title:
                  Text(DateFormat('MMMM d, y').format(widget.spot.time.start)),
              leading: Icon(
                CupertinoIcons.calendar,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: const Text("Availablility"),
              subtitle: Text(
                  '${DateFormat.jm().format(widget.spot.time.start)} - ${DateFormat.jm().format(widget.spot.time.end)}'),
              leading: Icon(
                CupertinoIcons.time,
                color: Colors.blue[500],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            //   child: Align(
            //       alignment: Alignment.bottomLeft,
            //       child: SizedBox(
            //         height: 40,
            //         width: 120,
            //         child: ElevatedButton(
            //             child: const Text('Delete Spot'), onPressed: () => {}
            //             // Navigator.push(
            //             //     context,
            //             //     MaterialPageRoute(
            //             //         builder: (BuildContext context) =>
            //             //             const AvailableSpotsPage(),
            //             //         fullscreenDialog: true)))),
            //             ),
            //       )),
            // )
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //       // title: const Text('Profile'),
    //       ),
    //   body: Center(
    //     child: SizedBox(
    //       width: MediaQuery.of(context).size.width,
    //       height: MediaQuery.of(context).size.height,
    //       child: ListView(
    //         shrinkWrap: true,
    //         padding: const EdgeInsets.all(20.0),
    //         children: <Widget>[
    //           Column(children: [
    //             Text(
    //               widget.spot.name,
    //               style: Theme.of(context).textTheme.displayLarge,
    //             ),
    //             Text(widget.spot.description),
    //           ]),
    //           Row(
    //             children: [
    //               Text("Starts: ",
    //                   style: Theme.of(context).textTheme.displaySmall),
    //               Text(widget.spot.time.end.toString()),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Text("Ends: ",
    //                   style: Theme.of(context).textTheme.displaySmall),
    //               Text(widget.spot.time.start.toString()),
    //             ],
    //           ),
    //           Column(
    //             children: [
    //               Text("Location: ",
    //                   style: Theme.of(context).textTheme.displayMedium),
    //               Text(widget.spot.address.addr),
    //               Text(widget.spot.address.zipcode),
    //               Text(widget.spot.address.locality),
    //               Text(widget.spot.address.region),
    //               Text(widget.spot.address.country),
    //             ],
    //           ),
    //           Column(
    //             children: [
    //               Text("Price",
    //                   style: Theme.of(context).textTheme.displayMedium),
    //               Text("\$${widget.spot.priceRate}/hour"),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
