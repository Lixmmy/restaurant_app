import 'package:restaurant_app/core/model/category.dart';
import 'package:restaurant_app/core/model/customer_reviews.dart';
import 'package:restaurant_app/core/model/menus.dart';

class DetailRestaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menus menus;
  final double rating;
  final List<CustomerReviews> customerReviews;

  const DetailRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.address,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) {
    return DetailRestaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'],
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
