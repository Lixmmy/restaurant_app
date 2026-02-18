import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:restaurant_app/core/error/exceptions.dart';
import 'package:restaurant_app/core/model/category.dart';
import 'package:restaurant_app/core/model/customer_reviews.dart';
import 'package:restaurant_app/core/model/detail_restaurant.dart';
import 'package:restaurant_app/core/model/drink.dart';
import 'package:restaurant_app/core/model/food.dart';
import 'package:restaurant_app/core/model/menus.dart';
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/provider/detail_restaurant_provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/detail_restaurant_provider/detail_restaurant_state.dart';
import 'package:restaurant_app/core/response/detail_restaurant_response.dart';
import 'package:restaurant_app/core/service/api_service.dart';

import 'list_restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late DetailRestaurantProvider detailRestaurantProvider;

  setUp(() {
    mockApiService = MockApiService();
    detailRestaurantProvider = DetailRestaurantProvider(mockApiService);
  });

  group('getDetailRestaurant', () {
    test('should be in initial state when created', () {
      expect(detailRestaurantProvider.state, isA<DetailRestaurantInitial>());
    });
    test(
      'should emit [Loading, Success] when fetching restaurant successfully',
      () async {
        final tRestaurant = Restaurants(
          id: "id_1",
          name: "Melting Pot",
          description:
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
          pictureId: "14",
          city: "Medan",
          rating: 4.2,
        );
        final tCategories = [
          Category(name: "Italia"),
          Category(name: "Modern"),
        ];
        final tCustomerReviews = [
          CustomerReviews(
            name: "Ahmad",
            review: "Tidak rekomendasi untuk pelajar!",
            date: "13 November 2019",
          ),
          CustomerReviews(
            name: "Trisa",
            review: "Balik lagi",
            date: "18 Februari 2026",
          ),
        ];
        final tMenus = Menus(
          foods: [
            Food(name: "Paket rosemary"),
            Food(name: "Toastie salmon"),
            Food(name: "Bebek crepes"),
            Food(name: "Salad lengkeng"),
          ],
          drinks: [
            Drink(name: "Es krim"),
            Drink(name: "Sirup"),
            Drink(name: "Jus apel"),
            Drink(name: "Jus jeruk"),
            Drink(name: "Coklat panas"),
            Drink(name: "Salad lengkeng"),
          ],
        );
        final tDetailRestaurant = DetailRestaurant(
          restaurants: tRestaurant,
          customerReviews: tCustomerReviews,
          address: "Address",
          categories: tCategories,
          menus: tMenus,
        );
        final tDetailRestaurantResponse = DetailRestaurantResponse(
          error: false,
          message: "success",
          restaurant: tDetailRestaurant,
        );

        when(
          mockApiService.getDetailRestaurant("id_1"),
        ).thenAnswer((_) async => tDetailRestaurantResponse);

        final states = <DetailRestaurantState>[];
        detailRestaurantProvider.addListener(() {
          states.add(detailRestaurantProvider.state);
        });

        await detailRestaurantProvider.getDetailRestaurant("id_1");

        expect(states[0], isA<DetailRestaurantLoading>());
        expect(states[1], isA<DetailRestaurantSuccess>());
        expect(
          (states[1] as DetailRestaurantSuccess).restaurant,
          tDetailRestaurant,
        );
      },
    );
    test(
      'should emit [Loading, Failure] when network call fails with NetworkException',
      () async {
        final tErrorMessage = 'No Internet Connection';
        when(
          mockApiService.getDetailRestaurant("id_1"),
        ).thenThrow(NetworkException(tErrorMessage));

        final states = <DetailRestaurantState>[];
        detailRestaurantProvider.addListener(() {
          states.add(detailRestaurantProvider.state);
        });

        await detailRestaurantProvider.getDetailRestaurant("id_1");

        expect(states[0], isA<DetailRestaurantLoading>());
        expect(states[1], isA<DetailRestaurantFailure>());
        expect((states[1] as DetailRestaurantFailure).message, tErrorMessage);
      },
    );
    test(
      'should emit [Loading, Failure] when network call fails with general Exception',
      () async {
        final tErrorMessage = 'An unexpected error occurred';

        when(
          mockApiService.getDetailRestaurant("id_1"),
        ).thenThrow(Exception(tErrorMessage));

        final states = <DetailRestaurantState>[];
        detailRestaurantProvider.addListener(() {
          states.add(detailRestaurantProvider.state);
        });

        await detailRestaurantProvider.getDetailRestaurant("id_1");

        expect(states[0], isA<DetailRestaurantLoading>());
        expect(states[1], isA<DetailRestaurantFailure>());
        expect(
          (states[1] as DetailRestaurantFailure).message,
          contains(tErrorMessage),
        );
      },
    );
  });
}
