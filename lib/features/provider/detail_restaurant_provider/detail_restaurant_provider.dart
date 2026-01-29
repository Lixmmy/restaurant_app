import 'package:flutter/material.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/features/provider/detail_restaurant_provider/detail_restaurant_state.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService _apiService;

  DetailRestaurantProvider(this._apiService);

  DetailRestaurantState _state = DetailRestaurantInitial();

  DetailRestaurantState get state => _state;

  Future<void> getDetailRestaurant(String id) async {
    try {
      _state = DetailRestaurantLoading();
      notifyListeners();
      final response = await _apiService.getDetailRestaurant(id);
      if (response.error) {
        _state = DetailRestaurantFailure(message: response.message);
        notifyListeners();
      } else {
        _state = DetailRestaurantSuccess(restaurant: response.restaurant!);
        notifyListeners();
      }
    } catch (e) {
      _state = DetailRestaurantFailure(message: e.toString());
      notifyListeners();
    }
  }
}
