import 'package:dio/dio.dart';
import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/features/login/login_binding.dart';
import 'package:sarmini_mbokdhe/features/login/login_screen.dart';
import 'package:sarmini_mbokdhe/network/interceptor.dart';

class ApiProvider {
  final baseUrl = 'http://admin.sarminimbokdhe.com';
  // final baseUrl = 'http://10.0.2.2:8000';
  final headers = {
    'Connection': 'Keep-Alive',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'http://admin.sarminimbokdhe.com/api',
        receiveTimeout: const Duration(seconds: 15),
        connectTimeout: const Duration(seconds: 15),
        headers: {'Connection': 'Keep-Alive', 'Accept': 'application/json'},
        receiveDataWhenStatusError: true),
  )..interceptors.add(CustomInterceptor());

  Future<dynamic> get({
    required String endpoint,
    String? token,
  }) async {
    try {
      final token = await Utils.readFromSecureStorage(key: Constants.token);
      headers['Authorization'] = 'Bearer $token';
      _dio.options.headers = headers;

      final response = await _dio.get(endpoint);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post({
    required String endpoint,
    required dynamic body,
    String? token,
  }) async {
    try {
      final token = await Utils.readFromSecureStorage(key: Constants.token);
      headers['Authorization'] = 'Bearer $token';
      _dio.options.headers = headers;

      final response = await _dio.post(endpoint, data: body);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postMultipart({
    required String endpoint,
    required dynamic body,
    String? token,
  }) async {
    try {
      final token = await Utils.readFromSecureStorage(key: Constants.token);
      headers['Authorization'] = 'Bearer $token';
      headers['Content-Type'] = Headers.multipartFormDataContentType;
      _dio.options.headers = headers;

      final response = await _dio.post(endpoint, data: body);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete({
    required String endpoint,
    required dynamic body,
    String? token,
  }) async {
    try {
      final token = await Utils.readFromSecureStorage(key: Constants.token);
      headers['Authorization'] = 'Bearer $token';
      _dio.options.headers = headers;

      final response = await _dio.delete(endpoint, data: body);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      rethrow;
    }
  }

  _handleResponse({required Response response}) {
    try {
      final data = response.data;
      return data;
    } catch (e) {
      rethrow;
    }
  }

  _handleError(DioException e) {
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        Get.offAll(
          () => const LoginScreen(),
          binding: LoginBinding(),
        );
      }
    }
    print(e.toString());
    throw e.message ?? 'Something happened!';
  }
}
