import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/provider/pagination_provider.dart';
import 'package:codefactory/order/model/order_model.dart';
import 'package:codefactory/order/model/post_order_body.dart';
import 'package:codefactory/order/repository/order_repository.dart';
import 'package:codefactory/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>(
  (ref) {
    final repo = ref.watch(orderRepositoryProvider);

    return OrderStateNotifier(
      ref: ref,
      repository: repo,
    );
  },
);

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    try {
      final state = ref.read(basketProvider);
      final id = const Uuid().v4();

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map((e) => PostOrderProductBody(
                    productId: e.product.id,
                    count: e.count,
                  ))
              .toList(),
          totalPrice: state.fold<int>(0, (p, n) => p + n.product.price),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
