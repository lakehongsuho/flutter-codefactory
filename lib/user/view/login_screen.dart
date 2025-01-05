import 'dart:convert';
import 'dart:io';

import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/common/utils/secure_storage.dart';
import 'package:codefactory/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/const/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    // const storage = FlutterSecureStorage();

    // localhost
    const emulatorIp = '10.0.2.2:3000';
    const simulatorIp = '127.0.0.1:3000';

    // 실제 기기에서 테스트할 때
    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
      // SingleChildScrollView 키보드가 올라올 때, 화면을 올려준다.
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        // 키보드가 올라왔을 때, 드래그하면 키보드가 내려가게 설정
        child: SafeArea(
          // 기계의 노치, 홈, 인디케이터, 상태 바 등을 고려하여 콘텐츠를 안전하게 표기해준다.
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  onChanged: (String value) {
                    username = value;
                  },
                  hintText: '이메일을 입력해주세요.',
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                  hintText: '비밀번호를 입력해주세요.',
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    // 아이디:비밀번호
                    // const rawString = 'test@codefactory.ai:testtest';
                    final rawString = '$username:$password';

                    // Base64 인코딩
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    // 인코딩된 문자열
                    String token = stringToBase64.encode(rawString);

                    // 로그인 요청
                    final response = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    // 토큰 저장
                    final refreshToken = response.data['refreshToken'];
                    final accessToken = response.data['accessToken'];

                    await ref
                        .read(secureStorageProvider)
                        .write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await ref
                        .read(secureStorageProvider)
                        .write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    // 로그인 성공 시, RootTab으로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RootTab(),
                      ),
                    );

                    // 응답 데이터(원래 로컬 서버면 레이턴시가 없는데, 일부로 넣어두었다.)
                    // print(response.data);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
