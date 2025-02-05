import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_my_way/features/go_ride/data/models/place.dart';
import 'package:on_my_way/features/go_ride/data/models/route_data.dart';

import '../../../../core/errors/failure.dart';

final osmRepoProvider = Provider.autoDispose<OsmRepo>(
  (ref) => OsmRepo(),
  name: "OSM Repo",
);

class OsmRepo {
  Future<Either<Failure, List<Place>>> searchAddress(String query) async {
    final String url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1";

    try {
      final response = await Dio().get(url);

      if (response.data != List.empty()) {
        final List<dynamic> dataList = response.data;
        final List<Place> places = [];
        for (var element in dataList) {
          if (element['address']['country'] == 'Egypt' ||
              element['address']['country'] == 'مصر') {
            places.add(Place.fromOSMResponse(element));
          }
        }
        return Right(places);
      } else {
        return const Left(MessageFailure("No Results"));
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(MessageFailure("An Error occured"));
    }
  }

  Future<Either<Failure, RouteData>> getRouteData({
    required LatLng startPoint,
    required LatLng endPoint,
  }) async {
    final String url =
        "http://router.project-osrm.org/route/v1/driving/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?steps=true&annotations=true&geometries=geojson";

    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final routeData = RouteData.fromOSMResponse(data);
        return Right(routeData);
      } else {
        return Left(MessageFailure(
            "Error fetching route data (status code: ${response.statusCode})"));
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      debugPrint("e.toString()");
      return const Left(MessageFailure("An error occurred"));
    }
  }
}
