import 'package:flutter/material.dart';
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/service/local_database_service.dart';

class FavoriteIconProvider extends ChangeNotifier {
  final LocalDatabaseService _localDatabaseService;
  final Restaurants _restaurant;
  bool _isFavorite = false;

  FavoriteIconProvider(
    this._localDatabaseService,
    this._restaurant,
  ) {
    _checkFavoriteStatus();
  }

  bool get isFavorite => _isFavorite;

  Future<void> _checkFavoriteStatus() async {
    final restaurant = await _localDatabaseService.getRestaurantById(
      _restaurant.id,
    );
    _isFavorite = restaurant != null;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    if (_isFavorite) {
      await _localDatabaseService.deleteRestaurant(_restaurant.id);
    } else {
      await _localDatabaseService.insertRestaurant(_restaurant);
    }
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

