import 'package:codefactory/common/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  late final String environment;
  final List<Future<void> Function()> _initializers = [];

  AppConfig() {
    _initializers.add(_initializeEnvironment);
    // 여기에 다른 초기화 함수들을 추가할 수 있습니다
    // 예: _initializers.add(_initializeDatabase);
    // 예: _initializers.add(_initializeAnalytics);
  }

  Future<void> initialize() async {
    for (final initializer in _initializers) {
      await initializer();
    }
  }

  Future<void> _initializeEnvironment() async {
    environment = kReleaseMode ? 'production' : 'development';

    try {
      await dotenv.load(fileName: '.env.$environment');
    } catch (e) {
      AppLogger.instance.e('환경 설정 파일을 불러오는데 실패했습니다: $e');
      dotenv.env['ENV'] = environment;
    }
  }
}
