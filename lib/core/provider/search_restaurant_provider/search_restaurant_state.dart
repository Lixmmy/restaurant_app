import 'package:restaurant_app/core/model/restaurants.dart';

sealed class SearchRestaurantState {}

class SearchRestaurantInitial extends SearchRestaurantState {}

class SearchRestaurantLoading extends SearchRestaurantState {}

class SearchRestaurantSuccess extends SearchRestaurantState {
  final List<Restaurants> restaurants;

  SearchRestaurantSuccess({required this.restaurants});
}

class SearchRestaurantFailure extends SearchRestaurantState {
  final String message;

  SearchRestaurantFailure({required this.message});
}
