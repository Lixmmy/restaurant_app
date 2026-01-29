import 'package:restaurant_app/core/model/restaurants.dart';

class ListRestaurantsResponse {
  bool error;
  int count;
  String message;
  List<Restaurants>? restaurants;

  ListRestaurantsResponse({
    required this.error,
    required this.count,
    required this.message,
    required this.restaurants,
  });

  factory ListRestaurantsResponse.fromJson(Map<String, dynamic> json) {
    return ListRestaurantsResponse(
      error: json['error'],
      count: json['count'],
      message: json['message'],
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => Restaurants.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
