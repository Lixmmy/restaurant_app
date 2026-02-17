import 'package:flutter/material.dart';
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/service/local_database_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _localDatabaseService;

  LocalDatabaseProvider(this._localDatabaseService);

  String _message = '';
  String get message => _message;

  List<Restaurants>? _restaurants;
  List<Restaurants>? get restaurants => _restaurants;

  Restaurants? _restaurant;
  Restaurants? get restaurant => _restaurant;

  Future<void> addRestaurant(Restaurants restaurant) async {
    try {
      final result = await _localDatabaseService.insertRestaurant(restaurant);
      final isError = result == 0;
      if (isError) {
        _message = 'Failed to add restaurant';
      } else {
        _message = 'Restaurant added to favorites';
        getRestaurantList();
      }
    } catch (e) {
      _message = 'Failed to add restaurant: $e';
    }
    notifyListeners();
  }

  Future<void> getRestaurantList() async {
    try {
      final result = await _localDatabaseService.getAllRestaurants();
      _restaurants = result;
      if (result.isEmpty) {
        _message = 'No favorite restaurants found';
      } else {
        _message = 'Successfully loaded all restaurants';
      }
      _restaurant = null;
      notifyListeners();
    } catch (e) {
      _message = 'Failed to load all restaurants: $e';
      notifyListeners();
    }
  }

  Future<void> getRestaurantById(String id) async {
    try {
      final result = await _localDatabaseService.getRestaurantById(id);
      _restaurant = null;
      if (result != null) {
        _restaurant = result;
        _message = 'Successfully loaded restaurant details';
      } else {
        _message = 'Restaurant not found';
      }
      notifyListeners();
    } catch (e) {
      _message = 'Failed to load restaurant details: $e';
      notifyListeners();
    }
  }

  Future<void> removeRestaurant(String id) async {
    try {
      final result = await _localDatabaseService.deleteRestaurant(id);
      final isError = result == 0;
      if (isError) {
        _message = 'Failed to remove restaurant';
      } else {
        _message = 'Restaurant removed from favorites';
        getRestaurantList();
      }
    } catch (e) {
      _message = 'Failed to remove restaurant: $e';
    }
    notifyListeners();
  }

  bool isFavorited(String id) {
    if (_restaurants != null) {
      return _restaurants!.any((restaurant) => restaurant.id == id);
    }
    return false;
  }
}
