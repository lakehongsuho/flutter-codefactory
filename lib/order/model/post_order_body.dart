import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable()
class PostOrderBody {
  final String id;
  final List<PostOrderProductBody> products;
  final int totalPrice;
  final String createdAt;

  PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
  });

  factory PostOrderBody.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable()
class PostOrderProductBody {
  final String productId;
  final int count;

  PostOrderProductBody({
    required this.productId,
    required this.count,
  });

  factory PostOrderProductBody.fromJson(Map<String, dynamic> json) =>
      _$PostOrderProductBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderProductBodyToJson(this);
}
