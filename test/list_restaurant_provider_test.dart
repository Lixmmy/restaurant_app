import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/core/error/exceptions.dart';
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_state.dart';
import 'package:restaurant_app/core/response/list_restaurants_response.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService apiService;
  late ListRestaurantProvider listRestaurantProvider;
  setUp(() {
    apiService = MockApiService();
    listRestaurantProvider = ListRestaurantProvider(apiService);
  });

  group('getListRestaurant', () {
    test('should be in initial state when created', () {
      expect(listRestaurantProvider.state, isA<ListRestaurantInitial>());
    });
    test(
      'should emit [Loading, Success] when fetching restaurants successfully',
      () async {
        final tRestaurant = Restaurants(
          id: "rqdv5juczeskfw1e867",
          name: "Melting Pot",
          description:
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
          pictureId: "14",
          city: "Medan",
          rating: 4.2,
        );
        final tListRestaurants = [tRestaurant];
        final tListRestaurantsResponse = ListRestaurantsResponse(
          error: false,
          message: "success",
          count: 1,
          restaurants: tListRestaurants,
        );

        when(
          apiService.getListRestaurants(),
        ).thenAnswer((_) async => tListRestaurantsResponse);

        final states = <ListRestaurantState>[];
        listRestaurantProvider.addListener(() {
          states.add(listRestaurantProvider.state);
        });

        await listRestaurantProvider.getListRestaurant();

        expect(states[0], isA<ListRestaurantLoading>());
        expect(states[1], isA<ListRestaurantSuccess>());
        expect(
          (states[1] as ListRestaurantSuccess).restaurants,
          tListRestaurants,
        );
      },
    );
    test(
      'should emit [Loading, Failure] when network call fails with NetworkException',
      () async {
        final tErrorMessage = 'No Internet Connection';

        when(
          apiService.getListRestaurants(),
        ).thenThrow(NetworkException(tErrorMessage));

        final states = <ListRestaurantState>[];
        listRestaurantProvider.addListener(() {
          states.add(listRestaurantProvider.state);
        });

        await listRestaurantProvider.getListRestaurant();

        expect(states[0], isA<ListRestaurantLoading>());
        expect(states[1], isA<ListRestaurantFailure>());
        expect((states[1] as ListRestaurantFailure).message, tErrorMessage);
      },
    );
    test(
      'should emit [Loading, Failure] when network call fails with general Exception',
      () async {
        final tErrorMessage = 'An unexpected error occurred';

        when(
          apiService.getListRestaurants(),
        ).thenThrow(Exception(tErrorMessage));

        final states = <ListRestaurantState>[];
        listRestaurantProvider.addListener(() {
          states.add(listRestaurantProvider.state);
        });

        await listRestaurantProvider.getListRestaurant();

        expect(states[0], isA<ListRestaurantLoading>());
        expect(states[1], isA<ListRestaurantFailure>());
        expect(
          (states[1] as ListRestaurantFailure).message,
          contains(tErrorMessage),
        );
      },
    );
  });
}
