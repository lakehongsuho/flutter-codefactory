import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/dio/dio.dart';
import 'package:codefactory/common/model/login_response.dart';
import 'package:codefactory/common/model/token_response.dart';
import 'package:codefactory/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(dio, "http://$ip/auth");
});

// 레트로핏을 이용하지 않음
class AuthRepository {
  final Dio dio;
  final String baseUrl;

  AuthRepository(this.dio, this.baseUrl);

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final response = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {'authorization': 'Basic $serialized'},
      ),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> token({
    required String refreshToken,
  }) async {
    final response = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(response.data);
  }
}
