import 'package:restaurant_app/core/model/detail_restaurant.dart';

sealed class DetailRestaurantState {}

final class DetailRestaurantInitial extends DetailRestaurantState {}

final class DetailRestaurantLoading extends DetailRestaurantState {}

final class DetailRestaurantSuccess extends DetailRestaurantState {
  final DetailRestaurant restaurant;

  DetailRestaurantSuccess({required this.restaurant});
}

final class DetailRestaurantFailure extends DetailRestaurantState {
  final String message;

  DetailRestaurantFailure({required this.message});
}
