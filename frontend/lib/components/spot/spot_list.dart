import 'package:flutter/material.dart';
import 'package:parkme/components/spot/spot.dart';
import 'package:parkme/components/spot/spot_card_v2.dart';

class SpotList extends StatelessWidget {
  // Future<List<Spot>> spots;
  final Function? onClick;
  Future<List<Spot>> data;
  SpotList({Key? key, required this.data, this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Spot>>(
      future: data,
      // itemCount: spots.length,
      builder: (futureContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (listContext, index) {
              return SpotCardV2(
                spot: snapshot.data![index],
                onClick: onClick,
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
