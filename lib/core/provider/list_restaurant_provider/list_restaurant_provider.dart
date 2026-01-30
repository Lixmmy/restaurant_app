import 'package:flutter/material.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_state.dart';

class ListRestaurantProvider extends ChangeNotifier {
  final ApiService _apiService;

  ListRestaurantProvider(this._apiService) {
    getListRestaurant();
  }

  ListRestaurantState _state = ListRestaurantInitial();

  ListRestaurantState get state => _state;

  Future<void> getListRestaurant() async {
    try {
      _state = ListRestaurantLoading();
      notifyListeners();
      final response = await _apiService.getListRestaurants();
      if (response.error) {
        _state = ListRestaurantFailure(message: response.message);
        notifyListeners();
      } else {
        _state = ListRestaurantSuccess(restaurants: response.restaurants!);
        notifyListeners();
      }
    } catch (e) {
      _state = ListRestaurantFailure(message: e.toString());
      notifyListeners();
    }
  }
}
