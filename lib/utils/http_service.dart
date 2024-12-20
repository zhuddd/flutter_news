import 'package:dio/dio.dart';

class HttpService {
  // 单例模式
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late Dio _dio;

  // 初始化 Dio
  void init({
    required String baseUrl,
    int connectTimeout = 5000,
    int receiveTimeout = 5000,
    Map<String, dynamic>? headers,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: headers,
    ));

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  // GET 请求
  Future<dynamic> get(String path, {Map<String, dynamic>? params,  Map<String, String>? headers}) async {
    try {
      Response response = await _dio.get(path, queryParameters: params, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST 请求
  Future<dynamic> post(String path, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT 请求
  Future<dynamic> put(String path, {Map<String, dynamic>? data, required Map<String, String> headers}) async {
    try {
      Response response = await _dio.put(path, data: data, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE 请求
  Future<dynamic> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.delete(path, data: data);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  // 处理错误
  dynamic _handleError(dynamic error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.connectionTimeout:
          return {'error': 'Connection Timeout'};
        case DioErrorType.sendTimeout:
          return {'error': 'Send Timeout'};
        case DioErrorType.receiveTimeout:
          return {'error': 'Receive Timeout'};
        case DioErrorType.badResponse:
          return {'error': 'Bad Response: ${error.response?.statusCode}'};
        case DioErrorType.cancel:
          return {'error': 'Request Cancelled'};
        case DioErrorType.unknown:
        default:
          return {'error': 'Unknown Error: ${error.message}'};
      }
    } else {
      return {'error': 'Unexpected Error: $error'};
    }
  }
}