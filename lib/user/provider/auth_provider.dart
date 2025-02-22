import 'dart:async';

import 'package:codefactory/common/view/root_tab.dart';
import 'package:codefactory/common/view/splash_screen.dart';
import 'package:codefactory/order/view/order_done_screen.dart';
import 'package:codefactory/restaurant/view/basket_screen.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:codefactory/user/model/user_model.dart';
import 'package:codefactory/user/provider/user_me_provider.dart';
import 'package:codefactory/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// changeNotifierProvider 사용하는 이유는 고라우터 때문이다.
final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

final class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      // userMeProvider 의 상태가 변경될 때마다 실행되는 코드
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // 고라우터 라우트 정보를 가져오는 함수
  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (context, state) => RestaurantDetailScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (context, state) => const BasketScreen(),
        ),
        GoRoute(
          path: '/order_done',
          name: OrderDoneScreen.routeName,
          builder: (context, state) => const OrderDoneScreen(),
        ),
      ];

  // 리다이렉트 로직
  // 앱이 처음 시작했을 때, 토큰이 존재하는지 확인하고 로그인 스크린 혹은 홈 스크린으로 리다이렉트 해준다.
  FutureOr<String?> redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final isLogin = state.location == '/login';

    // 유저 정보가 없는데 로그인 중이면 그대로 로그인 페이지에 둔다.
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동.
    if (user == null) {
      return isLogin ? null : '/login';
    }

    // 유저가 null이 아닌 경우

    // UserModel인 경우
    // 사용자 정보가 있는 상태이면서, 로그인 중이거나 현재 위치가 스플래시스크린이면 홈으로 이동.
    if (user is UserModel) {
      return isLogin || state.location == '/splash' ? '/' : null;
    }

    // UserModelError인 경우
    // 유저 정보가 없는 상태이면서, 로그인 중이면 로그인 페이지로 이동.
    if (user is UserModelError) {
      return !isLogin ? '/login' : null;
    }

    return null;
  }
}
