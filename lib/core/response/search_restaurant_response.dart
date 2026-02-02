import 'package:restaurant_app/core/model/restaurants.dart';

class SearchRestaurantResponse {
  final bool error;
  final int founded;
  final List<Restaurants> restaurants;

  SearchRestaurantResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurantResponse.fromJson(Map<String, dynamic> json) {
    return SearchRestaurantResponse(
      error: json['error'],
      founded: json['founded'],
      restaurants:
          (json['restaurants'] as List<dynamic>?)
              ?.map((e) => Restaurants.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <Restaurants>[],
    );
  }
}
