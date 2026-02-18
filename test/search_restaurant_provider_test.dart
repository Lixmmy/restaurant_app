import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/core/error/exceptions.dart';
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_state.dart';
import 'package:restaurant_app/core/response/search_restaurant_response.dart';
import 'package:restaurant_app/core/service/api_service.dart';

import 'list_restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late SearchRestaurantProvider searchRestaurantProvider;

  setUp(() {
    mockApiService = MockApiService();
    searchRestaurantProvider = SearchRestaurantProvider(mockApiService);
  });

  group('searchRestaurant', () {
    test('should be in initial state when created', () {
      expect(searchRestaurantProvider.state, isA<SearchRestaurantInitial>());
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

        final tsearchRestaurantResponse = SearchRestaurantResponse(
          error: false,
          founded: 1,
          restaurants: [tRestaurant],
        );

        when(
          mockApiService.getSearchRestaurant("id_1"),
        ).thenAnswer((_) async => tsearchRestaurantResponse);

        final states = <SearchRestaurantState>[];
        searchRestaurantProvider.addListener(() {
          states.add(searchRestaurantProvider.state);
        });

        await searchRestaurantProvider.searchRestaurant("id_1");

        expect(states[0], isA<SearchRestaurantLoading>());
        expect(states[1], isA<SearchRestaurantSuccess>());
        expect(
          (states[1] as SearchRestaurantSuccess).restaurants,
          tsearchRestaurantResponse.restaurants,
        );
      },
    );
    test(
      'should emit [Loading, Failure] when network call fails with NetworkException',
      () async {
        final tErrorMessage = 'No Internet Connection';
        when(
          mockApiService.getSearchRestaurant("id_1"),
        ).thenThrow(NetworkException(tErrorMessage));

        final states = <SearchRestaurantState>[];
        searchRestaurantProvider.addListener(() {
          states.add(searchRestaurantProvider.state);
        });

        await searchRestaurantProvider.searchRestaurant("id_1");

        expect(states[0], isA<SearchRestaurantLoading>());
        expect(states[1], isA<SearchRestaurantFailure>());
        expect((states[1] as SearchRestaurantFailure).message, tErrorMessage);
      },
    );
    test(
      'should emit [Loading, Failure] when network call fails with general Exception',
      () async {
        final tErrorMessage = 'An unexpected error occurred';

        when(
          mockApiService.getSearchRestaurant("id_1"),
        ).thenThrow(Exception(tErrorMessage));

        final states = <SearchRestaurantState>[];
        searchRestaurantProvider.addListener(() {
          states.add(searchRestaurantProvider.state);
        });

        await searchRestaurantProvider.searchRestaurant("id_1");

        expect(states[0], isA<SearchRestaurantLoading>());
        expect(states[1], isA<SearchRestaurantFailure>());
        expect(
          (states[1] as SearchRestaurantFailure).message,
          contains(tErrorMessage),
        );
      },
    );
  });
}
