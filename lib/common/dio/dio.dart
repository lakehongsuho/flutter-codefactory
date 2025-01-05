import 'package:codefactory/common/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/data.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    AppLogger.instance.i('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.instance.i(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    AppLogger.instance
        .i('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    // 인증 오류와 토큰 갱신 오류를 둘 다 처리해야 함
    // 인증 오류로 토큰을 갱신하지만, 토큰 갱신이 실패할 수도 있음
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 엑세스 토큰 인증 오류가 났을 때
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    }
    super.onError(err, handler);
  }
}
