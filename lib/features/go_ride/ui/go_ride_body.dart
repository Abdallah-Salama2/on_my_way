import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latlong2/latlong.dart';
import 'package:on_my_way/core/shared/widgets/back_button.dart';
import 'package:on_my_way/core/shared/widgets/dynamic_form_field.dart';
import 'package:on_my_way/core/styles/app_colors.dart';
import 'package:on_my_way/features/go_ride/providers/go_ride_state.dart';

import 'package:on_my_way/features/go_ride/providers/go_ride_provider.dart';
import 'package:on_my_way/features/go_ride/ui/widgets/go_ride_sheet.dart';

/// [GoRideBody] is not called a screen because it's not a scaffold
/// and is a part of [HomeScreen]'s navigation and doesn't have it's own route
///
/// Check `features/home/ui/home_screen.dart` for more details
class GoRideBody extends ConsumerStatefulWidget {
  const GoRideBody({super.key});

  @override
  ConsumerState<GoRideBody> createState() => _GoRideBodyState();
}

class _GoRideBodyState extends ConsumerState<GoRideBody> {
  bool isExpanded = false;

  final fromController = TextEditingController();
  final whereToController = TextEditingController();
  final whereToFocusNode = FocusNode();
  final MapController mapController = MapController();

  @override
  void dispose() {
    fromController.dispose();
    whereToController.dispose();
    whereToFocusNode.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final goRideNotifier = ref.read(goRideStateProvider.notifier);
    final goRideState = ref.watch(goRideStateProvider);
    final isCustomizingRide =
        (goRideState.rideState == RideState.choosingFrom ||
            goRideState.rideState == RideState.choosingWhereTo);

    return SafeArea(
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(51.509364, -0.128928),
              initialZoom: 9.2,
              onMapReady: () {
                goRideNotifier.initializeMapController(mapController);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: goRideState.routeData?.routePoints ?? [],
                    strokeWidth: 5,
                    gradientColors: [
                      AppColors.orangeSoda,
                      AppColors.chromeYellow,
                    ],
                  ),
                ],
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  if (goRideState.startPlace != null)
                    Marker(
                      point: goRideState.startPlace!.position,
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.orangeSoda,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  if (goRideState.endPlace != null)
                    Marker(
                      height: 55,
                      width: 55,
                      point: goRideState.endPlace!.position,
                      child: Stack(
                        children: [
                          const Center(
                            child: CircleAvatar(
                              backgroundColor: AppColors.yellowOrange,
                              radius: 12,
                              child: Icon(
                                Icons.circle,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 41,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.chromeYellow.withOpacity(0.3),
                                border: Border.all(
                                  color: AppColors.yellowOrange,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.yellowOrange,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
          if (isCustomizingRide)
            ColoredBox(
              color: isExpanded ? Colors.white : Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15)),
                        border:
                            Border(bottom: BorderSide(color: Colors.black38))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 44,
                              height: 44,
                            ),
                            const SizedBox(width: 12),
                            isExpanded
                                ? Text(
                                    'Plan your ride',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: AppColors.pumpkinOrange,
                                    ),
                                  )
                                : Flexible(
                                    child: DynamicFormField(
                                      controller: whereToController,
                                      hintText: 'Where to?',
                                      prefixIcon: const Icon(Icons.search),
                                      onTap: () {
                                        setState(() {
                                          isExpanded = true;
                                          whereToFocusNode.requestFocus();
                                        });
                                      },
                                    ),
                                  ),
                          ],
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Vertical line with a dot at the top
                                Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    const Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      width: 2,
                                      height: 47,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8),
                                    const Icon(
                                      Icons.square,
                                      size: 12,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // Input fields
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      DynamicFormField(
                                        hintText: 'From?',
                                        controller: fromController,
                                        onFieldSubmitted: (p0) {
                                          goRideNotifier.searchPlace(p0);
                                        },
                                        onTap: () {
                                          goRideNotifier.selectMode(
                                              RideState.choosingFrom);
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      DynamicFormField(
                                        hintText: 'Where to?',
                                        controller: whereToController,
                                        focusNode: whereToFocusNode,
                                        onFieldSubmitted: (p0) {
                                          goRideNotifier.searchPlace(p0);
                                        },
                                        onTap: () {
                                          goRideNotifier.selectMode(
                                              RideState.choosingWhereTo);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isExpanded) const SizedBox(height: 10),
                  if (isExpanded)
                    Expanded(
                      child: ListView.separated(
                        itemCount: goRideState.placeSearchResult.length,
                        itemBuilder: (context, index) {
                          final place = goRideState.placeSearchResult[index];
                          return ListTile(
                            onTap: () {
                              goRideNotifier.selectPlace(place);
                              if (goRideState.rideState ==
                                  RideState.choosingWhereTo) {
                                whereToController.text = place.name;
                              } else {
                                fromController.text = place.name;
                              }
                            },
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.davysGrey,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              place.name,
                              style: textTheme.bodyLarge?.copyWith(
                                  color: AppColors.pumpkinOrange,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              place.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black26,
                        ),
                      ),
                    )
                ],
              ),
            ),
          // Back Button
          Positioned(
            top: 15,
            left: 12,
            child: BackButtonWidget(
              color: AppColors.pumpkinOrange,
              iconColor: AppColors.white,
              onTap: () {
                switch (goRideState.rideState) {
                  case RideState.choosingFrom || RideState.choosingWhereTo:
                    if (isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                    break;
                  case RideState.orderingDriver:
                    goRideNotifier.selectMode(RideState.choosingWhereTo);
                    break;
                  case RideState.orderedDriver:
                    goRideNotifier.cancelRide();
                    break;
                  
                }
              },
            ),
          ),

          if (!isCustomizingRide) const GoRideSheet(),
        ],
      ),
    );
  }
}
