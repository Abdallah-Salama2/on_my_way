import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import 'package:on_my_way/core/errors/failure.dart';
import 'package:on_my_way/core/shared/helpers/dio_helper.dart';
import 'package:on_my_way/core/shared/helpers/hive_helper.dart';
import 'package:on_my_way/core/utils/api_constants.dart';
import 'package:on_my_way/features/authentication/data/models/auth_entity.dart';

final authRepoProvider = Provider.autoDispose<AuthRepo>(
  (ref) => AuthRepo(),
  name: "Auth Repo",
);

class AuthRepo {
  Future<Either<Failure, AuthEntity>> logIn({
    required String email,
    required String password,
    required bool remember,
  }) async {
    try {
      final response = await DioHelper.postData(
        path: ApiConstants.loginPath,
        body: {
          "email": email,
          "password": password,
          "remember": remember,
        },
      );
      if (response.data['success'] == true) {
        return Right(AuthEntity.fromJson(response.data));
      } else {
        log("Failed");
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      return const Left(MessageFailure("Error sending request"));
    } on FormatException catch (e) {
      debugPrint(e.source);
      return const Left(MessageFailure("Error sending request"));
    }
  }

  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await DioHelper.postData(
        path: ApiConstants.registerPath,
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "phone": phone,
          "address": address,
        },
      );
      if (response.data['success'] == true) {
        return Right(AuthEntity.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(MessageFailure("An Error occured"));
    }
  }

  Future<Either<Failure, bool>> logOut(String? token) async {
    try {
      final response = await DioHelper.deleteData(
        path: ApiConstants.logOutPath,
        token: token,
      );
      if (response.data['success'] == true) {
        return const Right(true);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(MessageFailure("An Error occured"));
    }
  }

  Future<Either<Failure, String>> sendEmail(String email) async {
    try {
      final response = await DioHelper.postData(
        path: ApiConstants.forgotPasswordPath,
        body: {
          "email": email,
        },
      );
      
      if (response.data['message'].toString().contains('success')) {
        return Right(response.data['message']);
      } else {
        return Left(ServerFailure(response.data['message']));
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      return const Left(MessageFailure("Error sending request"));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(MessageFailure("An Error occured"));
    }
  }

  void cacheAuthEntity(AuthEntity authEntity) {
    HiveHelper.putDataInHive(
      hiveBoxKey: HiveHelper.user,
      key: HiveHelper.user,
      value: authEntity.toJson(),
    );
  }

  void unCacheAuthEntity() {
    HiveHelper.putDataInHive(
      hiveBoxKey: HiveHelper.user,
      key: HiveHelper.user,
      value: {},
    );
  }

  AuthEntity? tryAutoLogin() {
    final data = HiveHelper.getDataFromHive(
      hiveBoxKey: HiveHelper.user,
      key: HiveHelper.user,
    );

    // log(data.toString());
    if (data.toString() == "{}" || data == null) {
      return null;
    }
    final encodedData = jsonEncode(data);
    return AuthEntity.fromJson(jsonDecode(encodedData));
  }
}
