import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/helpers/dio_helper.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/place.dart';
import '../models/drivers_entity.dart';

final ridesRepoProvider = Provider.autoDispose<RidesRepo>(
  (ref) => RidesRepo(),
  name: "Rides Repo Provider",
);

class RidesRepo {
  Future<Either<Failure, DriversEntity>> getDrivers({
    required Place dropOffLocation,
    required Place pickUpLocation,
    required String rideType,
    required int distance,
    required String token,
  }) async {
    try {
      final response = await DioHelper.postData(
        path: ApiConstants.getDrivers,
        token: token,
        body: {
          "dropOff": dropOffLocation.toJson(),
          "pickUp": pickUpLocation.toJson(),
          "rideType": rideType,
          "distance": distance,
        },
      );
      if (response.data['success'] == true) {
        return Right(DriversEntity.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return const Left(MessageFailure("Error sending request"));
    } on FormatException catch (e) {
      log(e.toString());
      log(e.source.toString());
      return const Left(MessageFailure("Error formatting request"));
    }
  }

  Future<Either<Failure, int>> createRide({
    required Place dropOffLocation,
    required Place pickUpLocation,
    required double fare,
    required int driverId,
    required String token,
  }) async {
    try {
      final response = await DioHelper.postData(
        path: ApiConstants.createRide,
        token: token,
        body: {
          "dropOff": dropOffLocation.toJson(),
          "pickUp": pickUpLocation.toJson(),
          "fare": fare,
          "driverId": driverId,
        },
      );
      if (response.data['success'] == true) {
        return Right(response.data['data']['id']);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      log(e.toString());
      return const Left(MessageFailure("Error formatting request"));
    }
  }

  Future<Either<Failure, String>> cancelRide({
    required int rideId,
    required String token,
  }) async {
    try {
      final response = await DioHelper.postData(
        path: ApiConstants.cancelRide(rideId.toString()),
        token: token,
      );
      if (response.data['success'] == true) {
        return Right(response.data['message']);
      } else {
        log(response.data['message']);
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      log(e.toString());
      return const Left(MessageFailure("An error occured"));
    }
  }
}
