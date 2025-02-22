import 'package:codefactory/common/component/pagination_list_view.dart';
import 'package:codefactory/order/components/order_card.dart';
import 'package:codefactory/order/model/order_model.dart';
import 'package:codefactory/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  static String routeName = 'order';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(context, index, model) =>
          OrderCard.fromModel(model: model),
    );
  }
}
