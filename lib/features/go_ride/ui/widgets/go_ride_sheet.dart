import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/go_ride/ui/widgets/ordering_driver_sheet.dart';

import 'package:on_my_way/features/go_ride/ui/widgets/trip_tracking_sheet.dart';

import '../../providers/go_ride_state.dart';
import '../../providers/go_ride_provider.dart';

class GoRideSheet extends ConsumerWidget {
  const GoRideSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRideState = ref.watch(goRideStateProvider);
    switch (goRideState.rideState) {
      case RideState.orderedDriver:
        return const TripTrackingSheet();
      // case RideState.riding:
      // return const TripDetailsSheet();
      case RideState.orderingDriver:
        return const OrderingDriverSheet();
      default:
        return const SizedBox.shrink();
    }
  }
}
