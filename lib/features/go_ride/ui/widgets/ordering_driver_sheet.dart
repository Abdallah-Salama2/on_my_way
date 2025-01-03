import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/utils/enums.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../home/data/models/home_state.dart';
import '../../../home/providers/home_state_provider.dart';
import '../../data/models/driver.dart';
import '../../providers/go_ride_provider.dart';

class OrderingDriverSheet extends ConsumerWidget {
  const OrderingDriverSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final goRideNotifier = ref.read(goRideStateProvider.notifier);
    final goRideState = ref.watch(goRideStateProvider);

    final isCar =
        ref.read(homeStateProvider).selectedServiceType == ServiceType.goCar;
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.15,
        maxChildSize: 0.45,
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
              ),
              controller: scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 4.5,
                        width: 75,
                        decoration: BoxDecoration(
                          color: AppColors.azureishWhite,
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Choose Trip',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(
                        color: AppColors.azureishWhite,
                        height: 2,
                      ),
                      const SizedBox(height: 12),
                      if (goRideState.driversEntity?.drivers.isEmpty ?? true)
                        const Text('No drivers found at the moment'),
                      for (final Driver driver
                          in goRideState.driversEntity?.drivers ?? [])
                        ColoredBox(
                          color: driver.id == goRideState.rideId
                              ? AppColors.peachPuff
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              goRideNotifier.selectDriver(driver.id);
                            },
                            leading: Image.asset(
                              isCar
                                  ? 'assets/car-icon.png'
                                  : 'goride-bike-icon.png',
                            ),
                            title: Text(
                              isCar ? 'GoCar' : 'GoRide',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Text('7-10 mins'),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.circle,
                                  size: 7.5,
                                  color: AppColors.grayX11,
                                ),
                                const Icon(
                                  Icons.person,
                                  color: AppColors.grayX11,
                                ),
                                Text(driver.vehicle.capacity.toString()),
                              ],
                            ),
                            trailing: Text(
                              "EGP ${driver.price.toString()}",
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            AppColors.boxShadowBlack26,
                          ],
                          border: Border(
                            top: BorderSide(
                              color: AppColors.platinum,
                            ),
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_atm_outlined,
                                  color: AppColors.orangeRed,
                                ),
                                const SizedBox(width: 5),
                                Text('Cash', style: textTheme.bodyLarge),
                                const SizedBox(width: 5),
                                const Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(62),
                                backgroundColor: AppColors.orangeRed,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: goRideState.requestState.isLoading ||
                                      goRideState.requestState.hasError ||
                                      goRideState.rideId == -1
                                  ? null
                                  : () {
                                      goRideNotifier.createRide();
                                    },
                              child: Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Order GoRide'),
                                      Text('ET 7-10 mins',
                                          style: TextStyle(fontSize: 16))
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    goRideState.driversEntity?.drivers
                                            .firstWhereOrNull(
                                              (element) =>
                                                  element.id ==
                                                  goRideState.rideId,
                                            )
                                            ?.price
                                            .toString() ??
                                        '',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12,
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.orangeRed,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
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
