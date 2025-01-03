import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/features/go_ride/providers/go_ride_provider.dart';
import 'package:on_my_way/features/home/data/models/home_state.dart';
import 'package:on_my_way/features/home/providers/home_state_provider.dart';

import '../../../../core/styles/app_colors.dart';

class TripTrackingSheet extends ConsumerWidget {
  const TripTrackingSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final goRideState = ref.read(goRideStateProvider);
    final goRideStateNotifier = ref.read(goRideStateProvider.notifier);

    final driverData = goRideState.driversEntity?.drivers.firstWhereOrNull(
      (element) {
        return goRideState.rideId == element.id;
      },
    );
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => LayoutBuilder(
          builder: (context, constraints) => DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                AppColors.boxShadowBlack26,
              ],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              controller: scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: Container(
                          height: 4.5,
                          width: 75,
                          decoration: BoxDecoration(
                            color: AppColors.azureishWhite,
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 45,
                                    height: 70,
                                  ),
                                  Image.asset(
                                    'assets/uber-car.png',
                                  )
                                ],
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        'https://via.placeholder.com/70',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    height: 45,
                                    right: 0,
                                    left: 0,
                                    bottom: -20,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.antiFlashWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '97%',
                                              style: textTheme.titleMedium,
                                            ),
                                            const SizedBox(width: 2),
                                            const Icon(
                                              Icons.thumb_up,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Car Information and Name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: AppColors.orangeRed,
                                    ),
                                    const SizedBox(width: 4),
                                    // ERROR HERE
                                    Flexible(
                                      child: Text(
                                        driverData?.name ?? 'Name',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: AppColors.orangeRed,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '• ${driverData?.vehicle.registrationNumber}',
                                      style: textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${driverData?.vehicle.color} ${driverData?.vehicle.model}",
                                  style: textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          // Phone Icon Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.antiFlashWhite,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: AppColors.darkGunMetal,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Send a message Button
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.antiFlashWhite,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Send a message',
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Tip Button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.antiFlashWhite,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add_circle_outlined,
                                  color: AppColors.darkGunMetal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tip',
                                  style: textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        thickness: 18,
                        color: AppColors.antiFlashWhite,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ride details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Pick-up Location',
                              style: TextStyle(color: AppColors.dimGray),
                            ),
                            Text(goRideState.startPlace?.name ?? "Location"),
                            const Divider(
                              height: 16,
                              color: AppColors.antiFlashWhite,
                              thickness: 2,
                            ),
                            const Text(
                              'Drop-off Location',
                              style: TextStyle(color: AppColors.dimGray),
                            ),
                            const Text('Location'),
                            const Divider(
                              height: 16,
                              color: AppColors.antiFlashWhite,
                              thickness: 2,
                            ),
                            const Text(
                              'Driver Name',
                              style: TextStyle(color: AppColors.dimGray),
                            ),
                            Text(driverData?.name ?? 'Name'),
                            const Divider(
                              height: 16,
                              color: AppColors.antiFlashWhite,
                              thickness: 2,
                            ),
                            const Text(
                              'Total',
                              style: TextStyle(color: AppColors.dimGray),
                            ),
                            Text(
                              "${driverData?.price.toString() ?? "Price"} EGP",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(
                              height: 16,
                              color: AppColors.antiFlashWhite,
                              thickness: 2,
                            ),
                            const Text(
                              'Service Type',
                              style: TextStyle(color: AppColors.dimGray),
                            ),
                            Text(
                              ref.read(homeStateProvider).selectedServiceType ==
                                      ServiceType.goRide
                                  ? "GoRide"
                                  : "GoCar",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 12,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: AppColors.orangeRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            goRideStateNotifier.cancelRide();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
