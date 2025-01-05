import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// 커서 페이지네이션 모델의 기본 클래스
abstract class CursorPaginationBase {}

// 커서 페이지네이션 모델의 에러 클래스
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// 커서 페이지네이션 모델의 로딩 클래스
class CursorPaginationLoading extends CursorPaginationBase {}

// 커서 페이지네이션 모델의 데이터 클래스

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

// 커서 페이지네이션 모델의 메타 클래스
@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 커서 페이지네이션 모델의 리패치 클래스
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 커서 페이지네이션 모델의 더 가져오기 클래스
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
