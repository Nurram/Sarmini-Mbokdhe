import 'dart:developer';

import 'package:dio/dio.dart';

class CustomInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('================= ERROR =================');
    log('${err.response}', name: 'ERROR:');
    log('=============== END ERROR ===============');
    
    final response = err.response;
    String? message = err.message;

    if(response != null) {
      message = response.data['message'];
    }

    handler.next(
      DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: err.error,
          stackTrace: err.stackTrace,
          message: message),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('================= ${options.method} =================');
    log('${options.uri}', name: 'URL:');
    log('${options.headers}', name: 'HEADER:');
    log('${options.data}', name: 'BODY:');
    log('=============== END ${options.method} ===============');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('================= RESPONSE =================');
    log('${response.data}', name: 'RESPONSE:');
    log('=============== END RESPONSE ===============');

    handler.next(response);
  }
}
