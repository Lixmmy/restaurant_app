import 'package:restaurant_app/core/model/category.dart';
import 'package:restaurant_app/core/model/customer_reviews.dart';
import 'package:restaurant_app/core/model/menus.dart';
import 'package:restaurant_app/core/model/restaurants.dart';

class DetailRestaurant {
  final Restaurants restaurants;
  final String address;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReviews> customerReviews;

  const DetailRestaurant({
    required this.restaurants,
    required this.address,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) {
    return DetailRestaurant(
      restaurants: Restaurants.fromJson(json),
      address: json['address'],
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      menus: Menus.fromJson(json['menus'] as Map<String, dynamic>),
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((e) => CustomerReviews.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
