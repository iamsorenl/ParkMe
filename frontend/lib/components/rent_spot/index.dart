import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkme/components/rent_spot/form_views/old.dart';
import 'package:parkme/components/rent_spot/form_views/parking_page.dart';
import 'package:parkme/components/rent_spot/form_views/old_rent_page.dart';
import 'package:parkme/components/spot/spot.dart';

class RentalPage extends StatefulWidget {
  final Spot spot;
  const RentalPage({Key? key, required this.spot}) : super(key: key);

  @override
  State<RentalPage> createState() => _RentalPage();
}

class _RentalPage extends State<RentalPage> {
  double currentPage = 0.0;

  MaterialBanner errorBanner(String text) {
    return MaterialBanner(
      padding: const EdgeInsets.all(20),
      content: Text(text),
      leading: const Icon(Icons.error),
      backgroundColor: Colors.red,
      actions: <Widget>[
        TextButton(
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          ),
          onPressed: () =>
              {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  Future<void> handleSubmit() async {}

  final controller = PageController();
  // static const duration = Duration(milliseconds: 300);
  // static const curve = Curves.ease;

  _onPageViewChange(int page) {
    setState(() {
      currentPage = page.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      /**
       * Put Form widgets here in an array
       */
      // RentPage(spot: widget.spot)
      ParkingPage(
        spot: widget.spot,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.spot.name),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: _onPageViewChange,
        children: pages,
      ),
      // persistentFooterButtons: <Widget>[
      //   Center(
      //     child: DotsIndicator(
      //       dotsCount: pages.length,
      //       position: currentPage,
      //     ),
      //   ),
      // ]
    );
  }
}
