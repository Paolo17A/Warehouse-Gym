import 'package:dio/dio.dart';
import 'package:the_warehouse_gym/core/config/app_config.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/auth_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  final Dio _dio;
  final AuthSecureStorage _storage;

  ApiClient({
    required AppConfig config,
    required AuthSecureStorage storage,
    Dio? dio,
  })  : _storage = storage,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _normalizeApiBaseUrl(config.apiBaseUrl),
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                headers: {'Content-Type': 'application/json'},
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  /// Accepts either `https://host` or `https://host/api`.
  static String _normalizeApiBaseUrl(String raw) {
    var base = raw.trim();
    while (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    if (base.endsWith('/api')) return base;
    return '$base/api';
  }

  Dio get dio => _dio;

  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? parser,
  }) async {
    final response =
        await _request(() => _dio.get(path, queryParameters: queryParameters));
    return _parseData(response, parser);
  }

  Future<T> postData<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) async {
    final response = await _request(() => _dio.post(path, data: body));
    return _parseData(response, parser);
  }

  Future<T> patchData<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) async {
    final response = await _request(() => _dio.patch(path, data: body));
    return _parseData(response, parser);
  }

  Future<T> deleteData<T>(
    String path, {
    T Function(dynamic json)? parser,
  }) async {
    final response = await _request(() => _dio.delete(path));
    return _parseData(response, parser);
  }

  Future<T> uploadMultipart<T>(
    String path, {
    required String field,
    required String filePath,
    T Function(dynamic json)? parser,
  }) async {
    final formData = FormData.fromMap({
      field: await MultipartFile.fromFile(filePath),
    });
    final response = await _request(
      () => _dio.post(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      ),
    );
    return _parseData(response, parser);
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  T _parseData<T>(Response<dynamic> response, T Function(dynamic json)? parser) {
    final bodyMap = _asStringKeyedMap(response.data);
    if (bodyMap == null) {
      throw const ApiException('Invalid response format.');
    }

    final success = bodyMap['success'] == true;
    if (!success) {
      final message = bodyMap['message']?.toString() ?? 'Request failed.';
      throw ApiException(message, statusCode: response.statusCode);
    }

    final data = bodyMap['data'];
    if (parser != null) return parser(data);

    if (data is Map) {
      return Map<String, dynamic>.from(data) as T;
    }
    return data as T;
  }

  ApiException _mapDioError(DioException e) {
    final response = e.response;
    final bodyMap = _asStringKeyedMap(response?.data);
    if (bodyMap != null) {
      final message =
          bodyMap['message']?.toString() ?? e.message ?? 'Request failed.';
      return ApiException(message, statusCode: response?.statusCode);
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const ApiException('Unable to reach the server.');
    }
    return ApiException(
      e.message ?? 'Request failed.',
      statusCode: response?.statusCode,
    );
  }

  static Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

ServerFailure toServerFailure(Object error) {
  if (error is ApiException) return ServerFailure(error.message);
  return ServerFailure(error.toString());
}
