import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/go_ride/data/models/drivers_entity.dart';
import 'package:on_my_way/features/go_ride/data/models/place.dart';

import '../data/models/route_data.dart';

enum RideState {
  choosingFrom,
  choosingWhereTo,
  orderingDriver,
  orderedDriver,
}

class GoRideState extends Equatable {
  final RouteData? routeData;
  final Place? startPlace;
  final Place? endPlace;
  final RideState rideState;
  final List<Place> placeSearchResult;
  final MapController? mapController;
  final String message;
  final RequestState placeSearchRequestState;
  final RequestState routeSearchRequestState;
  final RequestState requestState;
  final DriversEntity? driversEntity;
  final int rideId;

  const GoRideState({
    this.routeData,
    this.endPlace,
    this.startPlace,
    this.mapController,
    this.driversEntity,
    this.rideId = -1,
    this.rideState = RideState.choosingWhereTo,
    this.placeSearchRequestState = RequestState.initial,
    this.routeSearchRequestState = RequestState.initial,
    this.requestState = RequestState.initial,
    this.placeSearchResult = const [],
    this.message = '',
  });

  GoRideState copyWith({
    RouteData? routeData,
    Place? startPlace,
    Place? endPlace,
    MapController? mapController,
    RideState? rideState,
    RequestState? placeSearchRequestState,
    RequestState? routeSearchRequestState,
    RequestState? requestState,
    List<Place>? placeSearchResult,
    DriversEntity? driversEntity,
    String? message,
    int? rideId,
  }) {
    return GoRideState(
      routeData: routeData ?? this.routeData,
      startPlace: startPlace ?? this.startPlace,
      endPlace: endPlace ?? this.endPlace,
      mapController: mapController ?? this.mapController,
      rideState: rideState ?? this.rideState,
      driversEntity: driversEntity ?? this.driversEntity,
      placeSearchRequestState:
          placeSearchRequestState ?? this.placeSearchRequestState,
      routeSearchRequestState:
          routeSearchRequestState ?? this.routeSearchRequestState,
      requestState: requestState ?? this.requestState,
      placeSearchResult: placeSearchResult ?? this.placeSearchResult,
      message: message ?? this.message,
      rideId: rideId ?? this.rideId,
    );
  }

  @override
  List<Object?> get props {
    return [
      routeData,
      startPlace,
      endPlace,
      rideState,
      placeSearchRequestState,
      routeSearchRequestState,
      requestState,
      rideId,
      message,
      driversEntity,
    ];
  }
}
