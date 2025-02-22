import 'package:codefactory/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // watch가 아니라 read인 이유는 아래 GoRouter의 파라미터 값들은 authProvider의 값이 변경되는 경우는 흔하지 않기 때문이다.
  final provider = ref.read(authProvider);
  return GoRouter(
    routes: provider.routes,
    redirect: provider.redirectLogic,
    refreshListenable: provider,
    initialLocation: '/splash',
  );
});
