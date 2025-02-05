import 'package:on_my_way/features/home/data/models/home_state.dart';

enum NetworkStates {
  initial,
  connected,
  noConnection,
  restoredConnection,
  error,
}

enum RequestState {
  initial,
  loading,
  loaded,
  error,
}

extension RequestStateExtension on RequestState {
  bool get isLoading => this == RequestState.loading;
  bool get hasError => this == RequestState.error;
}

extension ServiceTypeExt on ServiceType {
  bool get isEcommerce =>
      this == ServiceType.goMart || this == ServiceType.goFood;

  bool get isGoFood => this == ServiceType.goFood;

  bool get isRideBooking =>
      this == ServiceType.goCar || this == ServiceType.goRide;
}
