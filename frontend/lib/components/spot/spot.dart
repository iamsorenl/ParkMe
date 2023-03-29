class SpotTime {
  final DateTime start;
  final DateTime end;

  SpotTime({required this.start, required this.end});
}

class StreetAddress {
  final String addr;
  final String zipcode;
  final String locality;
  final String region;
  final String country;

  StreetAddress(
      {required this.addr,
      required this.zipcode,
      required this.locality,
      required this.region,
      required this.country});
}

class Coords {
  final double lat;
  final double long;
  Coords({
    required this.lat,
    required this.long,
  });
}

class SpotType {
  final String id;
  final SpotTime time;
  final StreetAddress address;
  final Coords coords;
  final String description;
  final num priceRate;
  final String name;

  SpotType({
    required this.id,
    required this.time,
    required this.address,
    required this.coords,
    required this.description,
    required this.priceRate,
    required this.name,
  });
}

class Spot extends SpotType {
  Spot({
    required super.id,
    required super.time,
    required super.address,
    required super.coords,
    required super.description,
    required super.priceRate,
    required super.name,
  });
}

Spot jsonToSpot(json) {
  //print('this is json');
  //print(json);
  final startTime = DateTime.parse(json['time']['start']).toUtc().toLocal();
  final endTime = DateTime.parse(json['time']['end']).toUtc().toLocal();
  return Spot(
    id: json['id'],
    name: json['name'],
    priceRate: json['priceRate'],
    time: SpotTime(start: startTime, end: endTime),
    address: StreetAddress(
        addr: json['address']['addr'],
        zipcode: json['address']['zipcode'],
        locality: json['address']['locality'],
        region: json['address']['region'],
        country: json['address']['country']),
    coords: Coords(lat: json['coords']['lat'], long: json['coords']['long']),
    description: json['description'],
  );
}
