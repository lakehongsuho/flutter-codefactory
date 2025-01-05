import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
// import 'package:intl/intl.dart';

class AppLogger {
  static final Logger _logger = Logger(
    level: _getLogLevel(), // 환경에 따라 로그 레벨 설정
    printer: PrettyPrinter(
      printEmojis: true,
      colors: true,
      methodCount: 0,
      errorMethodCount: 8,
      // dateTimeFormat: (dateTime) => DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toLocal()),
    ),
  );

  static Logger get instance => _logger;

  // 환경에 따라 로그 레벨을 반환하는 메서드
  static Level _getLogLevel() {
    // 환경 변수에 따라 적절한 .env 파일 로드
    if (kReleaseMode) {
      return Level.warning; // 프로덕션 환경에서는 경고 이상의 로그만 출력
    } else {
      return Level.debug; // 개발 환경에서는 정보 이상의 로그 출력
    }
  }
}

// logger 패키지에서 제공하는 로그 레벨은 다음과 같습니다. 각 레벨은 로그의 중요도에 따라 다르게 사용됩니다:
// Level.verbose: 가장 낮은 로그 레벨로, 매우 상세한 정보를 기록할 때 사용합니다. 주로 디버깅 목적으로 사용됩니다.
// Level.debug: 디버깅 정보를 기록할 때 사용합니다. 개발 중에 유용한 정보를 출력하는 데 적합합니다.
// Level.info: 일반적인 정보를 기록할 때 사용합니다. 애플리케이션의 정상적인 동작을 설명하는 로그에 적합합니다.
// Level.warning: 경고를 기록할 때 사용합니다. 잠재적인 문제를 나타내며, 주의가 필요한 상황을 기록합니다.
// Level.error: 오류를 기록할 때 사용합니다. 애플리케이션의 기능에 영향을 미치는 문제를 나타냅니다.
// Level.wtf: 심각한 오류를 기록할 때 사용합니다. "What a Terrible Failure"의 약자로, 매우 심각한 문제를 나타냅니다.
// 이러한 로그 레벨을 적절히 사용하여, 개발 환경과 프로덕션 환경에서 필요한 로그만 출력하도록 설정할 수 있습니다. 로그 레벨을 설정하면, 해당 레벨 이상의 로그만 출력되도록 필터링할 수 있습니다.
