import 'package:restaurant_app/core/model/restaurants.dart';

class ListRestaurantsResponse {
  bool error;
  int founded;
  List<Restaurants>? restaurants;

  ListRestaurantsResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory ListRestaurantsResponse.fromJson(Map<String, dynamic> json) {
    return ListRestaurantsResponse(
      error: json['error'],
      founded: json['founded'],
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => Restaurants.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
