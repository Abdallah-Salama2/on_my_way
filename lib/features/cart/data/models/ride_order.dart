import 'package:equatable/equatable.dart';

import '../../../go_ride/data/models/place.dart';

class RideOrderModel extends Equatable {
  final int id;
  final int? pickupLocationId;
  final int? dropOffLocationId;
  final int? userId;
  final int? driverId;
  final String fare;
  final String status;
  final Place? pickupRideLocation;
  final Place? dropOffRideLocation;

  const RideOrderModel({
    required this.id,
    required this.pickupLocationId,
    required this.dropOffLocationId,
    required this.userId,
    required this.driverId,
    required this.fare,
    required this.status,
    required this.pickupRideLocation,
    required this.dropOffRideLocation,
  });

  factory RideOrderModel.fromJson(Map<String, dynamic> json) => RideOrderModel(
        id: json['id'],
        pickupLocationId: json['pickup_location_id'] as int?,
        dropOffLocationId: json['drop_off_location_id'] as int?,
        userId: json['user_id'] as int?,
        driverId: json['driver_id'] as int?,
        fare: json['fare'],
        status: json['status'],
        pickupRideLocation: json['pickup_ride_location'] != null
            ? Place.fromJson(json['pickup_ride_location'])
            : null,
        dropOffRideLocation: json['drop_off_ride_location'] != null
            ? Place.fromJson(json['drop_off_ride_location'])
            : null,
      );

  // @override
  // bool? get stringify => false;

  @override
  List<Object?> get props => [
        id,
        pickupLocationId,
        dropOffLocationId,
        userId,
        driverId,
        fare,
        status,
        pickupRideLocation,
        dropOffRideLocation,
      ];
}
