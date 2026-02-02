import 'package:flutter/material.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService _apiService;

  SearchRestaurantProvider(this._apiService);

  SearchRestaurantState _state = SearchRestaurantInitial();

  SearchRestaurantState get state => _state;

  Future<void> searchRestaurant(String query) async {
    try {
      _state = SearchRestaurantLoading();
      notifyListeners();
      final response = await _apiService.searchRestaurant(query);
      if (response.error) {
        _state = SearchRestaurantFailure(
          message: 'Tidak ada restaurant yang ditemukan',
        );
        notifyListeners();
      } else {
        _state = SearchRestaurantSuccess(restaurants: response.restaurants);
        notifyListeners();
      }
    } catch (e) {
      _state = SearchRestaurantFailure(message: e.toString());
      notifyListeners();
    }
  }
}
