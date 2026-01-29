import 'package:restaurant_app/core/model/detail_restaurant.dart';

class DetailRestaurantResponse {
  bool error;
  String message;
  DetailRestaurant? restaurant;

  DetailRestaurantResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });
  factory DetailRestaurantResponse.fromJson(Map<String, dynamic> json) {
    return DetailRestaurantResponse(
      error: json['error'],
      message: json['message'],
      restaurant: json['restaurant'] != null
          ? DetailRestaurant.fromJson(json['restaurant'])
          : null,
    );
  }
}
