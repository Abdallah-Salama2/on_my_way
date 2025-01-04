import 'package:dio/dio.dart';
import 'package:on_my_way/core/utils/api_constants.dart';

class DioHelper {
  static Dio? _dio;

  DioHelper._();

  static void init() {
    _dio ??= Dio(
      BaseOptions(
        sendTimeout: const Duration(seconds: 10),
        connectTimeout: const Duration(seconds: 5),
        baseUrl: ApiConstants.baseUrl,
        receiveTimeout: const Duration(
          seconds: 30,
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        followRedirects: true, // Enable following redirects
        maxRedirects: 5, // Optional: Limit the number of redirects
        validateStatus: (status) => status != null,
      ),
    );
  }

  //Get
  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = _dio!.get(
      path,
      queryParameters: queryParameters,
      data: body,
      options: Options(
        headers: {
          "Authorization": token == null ? "" : "Bearer $token",
        },
      ),
    );
    return response;
  }

  //Post
  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = _dio!.post(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          "Authorization": token == null ? "" : "Bearer $token",
        },
      ),
      data: body,
    );
    return response;
  }

  //Put
  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = _dio!.put(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          "Authorization": token == null ? "" : "Bearer $token",
        },
      ),
      data: body,
    );
    return response;
  }

  //Delete
  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = _dio!.delete(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          "Authorization": token == null ? "" : "Bearer $token",
        },
      ),
      data: body,
    );
    return response;
  }
}
