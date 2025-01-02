import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_my_way/core/shared/helpers/dio_helper.dart';
import 'package:on_my_way/features/authentication/data/repos/auth_repo.dart';
import 'package:on_my_way/features/go_ride/data/models/place.dart';

import 'package:on_my_way/features/go_ride/data/repos/osm_repo.dart';
import 'package:on_my_way/features/go_ride/data/repos/rides_repo.dart';

void main() async {
  DioHelper.init();

  test('OSM Repo Test', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final osmRepo = container.read(osmRepoProvider);

    // Perform the test
    final addressResult = await osmRepo.searchAddress("El tahrir square");

    // Assert the result
    addressResult.fold(
      (failure) {
        log("Error: ${failure.message}");
        fail(
            "Expected a successful response but got an error: ${failure.message}");
      },
      (success) {
        log(success.toString());
        expect(success.isNotEmpty, true,
            reason: "Expected at least one result");
        expect(success.first.name, "ميدان التحرير");
      },
    );

    // Perform the test
    final routeResult = await osmRepo.getRouteData(
      startPoint: const LatLng(29.976480, 31.131302),
      endPoint: const LatLng(30.043333, 31.236667),
    );

    // Assert the result
    routeResult.fold(
      (failure) {
        log("Error: ${failure.message}");
        fail(
            "Expected a successful response but got an error: ${failure.message}");
      },
      (success) {
        log(success.toString());
        expect(success.routePoints.isNotEmpty, true,
            reason: "Expected at least one result");
      },
    );
  });

  test('Auth Repo Test', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final authRepo = container.read(authRepoProvider);

    final logInResult = await authRepo.logIn(
      email: 'afas200032@gmail.com',
      password: '12345678910',
      remember: false,
    );

    String token = '';
    logInResult.fold(
      (failure) {
        log("Error: ${failure.message}");
        fail(
            "Expected a successful response but got an error: ${failure.message}");
      },
      (success) {
        log(success.toString());
        token = success.data.token;
        expect(success.success, true, reason: "Log in success");
      },
    );
    if (token.isNotEmpty) {
      final result = await authRepo.logOut(token);

      result.fold(
        (failure) {
          log("Error: ${failure.message}");
          fail(
              "Expected a successful response but got an error: ${failure.message}");
        },
        (success) {
          log(success.toString());
          expect(success, true, reason: "Log out success");
        },
      );
    }
  });

  test('Rides Repo Test', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final ridesRepo = container.read(ridesRepoProvider);

    final getDriversResult = await ridesRepo.getDrivers(
      dropOffLocation: const Place(
        name: "name",
        displayName: "display name",
        position: LatLng(12, 12),
      ),
      pickUpLocation: const Place(
        name: "name",
        displayName: "display name",
        position: LatLng(12, 12),
      ),
      distance: 33,
      rideType: "car",
      token: "3|CRv2jEdsNyfBAnuD99AQgoguDYur7qVNkYzZvpWb20c2016f",
    );

    getDriversResult.fold(
      (failure) {
        log("Error: ${failure.message}");
        fail(
            "Expected a successful response but got an error: ${failure.message}");
      },
      (success) {
        log(success.toString());

        expect(success.success, true, reason: "Response success");
      },
    );

    final createRideResult = await ridesRepo.createRide(
      dropOffLocation: const Place(
        name: "name",
        displayName: "display name",
        position: LatLng(12, 12),
      ),
      pickUpLocation: const Place(
        name: "name",
        displayName: "display name",
        position: LatLng(12, 12),
      ),
      fare: 33,
      driverId: 4,
      token: "3|CRv2jEdsNyfBAnuD99AQgoguDYur7qVNkYzZvpWb20c2016f",
    );

    createRideResult.fold(
      (failure) {
        log("Error: ${failure.message}");
        fail(
            "Expected a successful response but got an error: ${failure.message}");
      },
      (success) {
        log(success.toString());
        expect(true, true, reason: "Response success");
      },
    );

    final cancelRideResult = await ridesRepo.cancelRide(
      driverId: 4,
      token: "3|CRv2jEdsNyfBAnuD99AQgoguDYur7qVNkYzZvpWb20c2016f",
    );

    cancelRideResult.fold(
      (failure) {
        log("Error: ${failure.message}");
        fail(
            "Expected a successful response but got an error: ${failure.message}");
      },
      (success) {
        log(success.toString());
        expect(true, true, reason: "Response success");
      },
    );
  });
}
