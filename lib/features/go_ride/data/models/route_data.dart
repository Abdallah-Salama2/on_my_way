import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class RouteData extends Equatable {
  /// Distance in `meters`
  final num distance;
  final List<LatLng> routePoints;

  const RouteData({
    required this.distance,
    required this.routePoints,
  });

  double get distanceInKm {
    return distance / 1000;
  }

  factory RouteData.fromOSMResponse(dynamic json) {
    final distance = json['routes'][0]['distance'];
    final routePoints = (json['routes'][0]['geometry']['coordinates']
            as List<dynamic>)
        .map((point) => LatLng(point[1], point[0])) // Reverse order for lat/lng
        .toList();

    return RouteData(distance: distance.round(), routePoints: routePoints);
  }

  @override
  List<Object?> get props => [distance, routePoints];

  @override
  bool? get stringify => false;
}
