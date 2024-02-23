import 'package:dio/dio.dart';
import 'package:sarmini_mbokdhe/network/interceptor.dart';

class ApiProvider {
  final baseUrl = 'http://10.0.2.2:8000';

  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api',
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
      final response = await _dio.get(endpoint);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
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
      final response = await _dio.post(endpoint, data: body);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
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
      final response = await _dio.delete(endpoint, data: body);
      return _handleResponse(response: response);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
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
}
