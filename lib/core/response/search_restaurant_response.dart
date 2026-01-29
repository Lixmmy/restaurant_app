import 'package:restaurant_app/core/model/restaurants.dart';

class SearchRestaurantResponse {
  final bool error;
  final String message;
  final List<Restaurants>? restaurants;

  SearchRestaurantResponse({
    required this.error,
    required this.message,
    required this.restaurants,
  });

  factory SearchRestaurantResponse.fromJson(Map<String, dynamic> json) {
    return SearchRestaurantResponse(
      error: json['error'],
      message: json['message'],
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => Restaurants.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
