import 'package:restaurant_app/core/model/restaurants.dart';

sealed class ListRestaurantState {}

final class ListRestaurantInitial extends ListRestaurantState {}

final class ListRestaurantLoading extends ListRestaurantState {}

final class ListRestaurantSuccess extends ListRestaurantState {
  final List<Restaurants> restaurants;

  ListRestaurantSuccess({required this.restaurants});
}

final class ListRestaurantFailure extends ListRestaurantState {
  final String message;

  ListRestaurantFailure({required this.message});
}
