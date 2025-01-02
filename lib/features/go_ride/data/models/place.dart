import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Place extends Equatable {
  final String name;
  final String displayName;
  final LatLng position;

  const Place({
    required this.name,
    required this.displayName,
    required this.position,
  });

  factory Place.fromOSMResponse(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      displayName: json['display_name'],
      position: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['address'],
      displayName: json['address'],
      position: LatLng(json['latitude'], json['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
        'address': name,
        'lat': position.longitude,
        'long': position.longitude,
      };

  @override
  List<Object?> get props => [name, displayName, position];
}
