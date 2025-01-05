import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

// 작동 방식
// Retrofit이 이 추상 클래스를 기반으로 실제 구현체를 자동 생성합니다.
// API 호출 시 정의된 어노테이션을 기반으로 HTTP 요청을 구성합니다.
// 응답 데이터는 정의된 모델 클래스(RestaurantModel, RestaurantDetailModel)로 자동 변환됩니다.
// 4. 페이지네이션된 데이터는 CursorPagination 모델을 통해 처리됩니다.

@RestApi()
abstract class RestaurantRepository {
  // RestAPI 통신을 위한 인터페이스
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository; // 자동으로 생성된 구현체

  // http://$ip/restaurant
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/{id}
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String id,
  });
}
