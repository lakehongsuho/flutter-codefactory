import 'package:codefactory/common/utils/app_config.dart';
import 'package:codefactory/common/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // 플러터 엔진과 네이티브 플랫폼 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 앱 설정 초기화(환경 설정 파일 로드 등)
  final config = AppConfig();
  await config.initialize();
  runApp(
    ProviderScope(child: _App()),
  );
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
