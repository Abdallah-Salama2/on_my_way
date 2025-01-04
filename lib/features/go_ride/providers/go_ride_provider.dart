import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/helpers/ftoast_helper.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/providers/auth_provider.dart';
import 'package:on_my_way/features/go_ride/data/repos/osm_repo.dart';
import 'package:on_my_way/features/go_ride/data/repos/rides_repo.dart';
import 'package:on_my_way/features/home/data/models/home_state.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import 'go_ride_state.dart';
import '../data/models/place.dart';

final goRideStateProvider = NotifierProvider<GoRideStateProvider, GoRideState>(
  GoRideStateProvider.new,
  name: "GoRideStateProvider",
);

class GoRideStateProvider extends Notifier<GoRideState> {
  late final _osmRepo = ref.read(osmRepoProvider);
  late final _ridesRepo = ref.read(ridesRepoProvider);
  late final _authState = ref.read(authStateProvider);

  @override
  GoRideState build() {
    return const GoRideState();
  }

  Future<void> cancelRide() async {
    try {
      state = state.copyWith(requestState: RequestState.loading);

      final result = await _ridesRepo.cancelRide(
        rideId: state.rideId,
        token: _authState.authEntity!.data.token,
      );

      result.fold(
        (l) {
          state = state.copyWith(
            requestState: RequestState.error,
            message: l.message,
          );
          FtoastHelper.showErrorToast(l.message);
        },
        (r) {
          state = state.copyWith(
            requestState: RequestState.loaded,
            rideState: RideState.orderingDriver,
            driverId: -1,
            message: r,
          );
        },
      );
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        requestState: RequestState.error,
        message: "An error occured",
      );
    }
  }

  Future<void> createRide() async {
    try {
      state = state.copyWith(requestState: RequestState.loading);

      final result = await _ridesRepo.createRide(
        dropOffLocation: state.startPlace!,
        pickUpLocation: state.endPlace!,
        driverId: state.driverId,
        fare: state.driversEntity!.drivers
            .firstWhereOrNull(
              (element) => element.id == state.driverId,
            )!
            .price,
        token: _authState.authEntity!.data.token,
      );

      result.fold(
        (l) {
          state = state.copyWith(
            requestState: RequestState.error,
            message: l.message,
          );
          FtoastHelper.showErrorToast(l.message);
        },
        (r) {
          state = state.copyWith(
            requestState: RequestState.loaded,
            rideId: r,
            rideState: RideState.orderedDriver,
          );
        },
      );
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        requestState: RequestState.error,
        message: "An error occured",
      );
    }
  }

  Future<void> _getRides() async {
    try {
      state = state.copyWith(requestState: RequestState.loading);

      final result = await _ridesRepo.getDrivers(
        dropOffLocation: state.startPlace!,
        pickUpLocation: state.endPlace!,
        rideType:
            ref.read(homeStateProvider).selectedServiceType == ServiceType.goCar
                ? "car"
                : "bike",
        distance: state.routeData!.distance.toInt(),
        token: _authState.authEntity!.data.token,
      );

      result.fold(
        (l) {
          state = state.copyWith(
            requestState: RequestState.error,
            message: l.message,
          );
          FtoastHelper.showErrorToast(l.message);
        },
        (r) {
          state = state.copyWith(
            driversEntity: r,
            requestState: RequestState.loaded,
            message: '',
          );
          if (r.drivers.isEmpty) {
            FtoastHelper.showSuccessToast("No drivers found at the moment");
          }
        },
      );
    } catch (e) {
      log(e.toString());
      state = state.copyWith(
        requestState: RequestState.error,
        message: "An error occured",
      );
    }
  }

  Future<void> _getRouteData() async {
    if (state.endPlace != null && state.startPlace != null) {
      state = state.copyWith(routeSearchRequestState: RequestState.loading);
      final result = await _osmRepo.getRouteData(
        startPoint: state.startPlace!.position,
        endPoint: state.endPlace!.position,
      );

      result.fold(
        (l) {
          state = state.copyWith(
            routeSearchRequestState: RequestState.error,
            message: l.message,
          );
          FtoastHelper.showErrorToast(l.message);
        },
        (r) {
          state = state.copyWith(
            routeData: r,
            routeSearchRequestState: RequestState.loaded,
            rideState: RideState.orderingDriver,
          );
          _getRides();
          state.mapController?.move(state.endPlace!.position, 9);
        },
      );
    }
  }

  Future<void> searchPlace(String query) async {
    if (query.isNotEmpty) {
      state = state.copyWith(placeSearchRequestState: RequestState.loading);
      final result = await _osmRepo.searchAddress(query);

      result.fold(
        (l) {
          state = state.copyWith(
            placeSearchRequestState: RequestState.error,
            message: l.message,
          );
          FtoastHelper.showErrorToast(l.message);
        },
        (r) {
          state = state.copyWith(
            placeSearchResult: r,
            placeSearchRequestState: RequestState.loaded,
          );
        },
      );
    }
  }

  void selectPlace(Place place) {
    if (state.rideState == RideState.choosingFrom) {
      state = state.copyWith(startPlace: place);
      _getRouteData();
    } else if (state.rideState == RideState.choosingWhereTo) {
      state = state.copyWith(endPlace: place);
      _getRouteData();
    }
    return;
  }

  void selectMode(RideState rideState) {
    state = state.copyWith(rideState: rideState);
  }

  void selectDriver(int id) {
    state = state.copyWith(driverId: id);
  }

  void initializeMapController(MapController mapController) {
    state = state.copyWith(mapController: mapController);
  }
}
