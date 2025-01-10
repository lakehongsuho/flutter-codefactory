import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/model/pagination_params.dart';
import 'package:codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    // 페치 개수
    int fetchCount = 20,
    // 더 가져오기 여부, true = 더 가져오기, false = 새로고침
    bool fetchMore = false,
    // 강제 리패치 여부, true = CursorPaginationLoading, false = CursorPaginationRefetching
    bool forceRefetch = false,
  }) async {
    try {
      // 1. 페이지네이션 진행하지 않는 경우

      // 백엔드에서 남은 데이터가 없고, 사용자가 강제 리페치하지 않는 경우
      // 더 이상 페이지네이션을 진행하지 않음
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      // 사용자가 리페칭을 하지만
      // 이미 로딩중이거나, 리페칭중이거나, 데이터를 더 불러오는 경우
      // 더 이상 페이지네이션을 진행하지 않음
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 2. 추가 데이터를 불러오는 경우

      // 페이지네이션 파라미터 인스턴스 생성
      PaginationParams pParams = PaginationParams(
        count: fetchCount,
      );

      // 뷰에서 fetchMore가 true인 경우
      // state는 이미 데이터가 있는 상태라서 CursorPagination인 상태
      // state를 CursorPaginationFetchingMore로 변경
      // 파라미터에 마지막 데이터의 id를 추가
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        pParams = pParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 3. 처음부터 데이터를 불러오는 경우
      else {
        // 이미 데이터가 있으면서,
        // 기존의 데이터를 보존하고 리페칭하는 경우
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 데이터가 없는 경우
        else {
          state = CursorPaginationLoading();
        }
      }

      // 데이터 페치
      // fetchMore가 아닌 경우, 페이지네이션에서 갯수 파라미터만 추가
      final resp = await repository.paginate(paginationParams: pParams);

      // 기존 데이터에 페치한 데이터 추가
      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = pState.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        // 처음부터 데이터를 불러오는 경우
        // state의 타입은 CursorPagination<RestaurantModel>
        state = resp;
      }
    } catch (e) {
      // 4. 에러 발생 시
      state = CursorPaginationError(message: e.toString());
    }
  }
}
