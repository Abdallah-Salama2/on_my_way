import 'package:equatable/equatable.dart';

enum ServiceType {
  goCar,
  goRide,
  goFood,
  goMart;
}

class HomeState extends Equatable {
  final ServiceType? selectedServiceType;

  const HomeState({this.selectedServiceType});

  HomeState copyWith({
    ServiceType? selectedServiceType,
  }) {
    return HomeState(
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
    );
  }

  @override
  List<Object?> get props => [selectedServiceType];
}
