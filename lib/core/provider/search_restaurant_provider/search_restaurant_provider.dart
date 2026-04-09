import 'package:flutter/material.dart';
import 'package:restaurant_app/core/error/exceptions.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService _apiService;
  String _query = '';

  SearchRestaurantProvider(this._apiService);

  SearchRestaurantState _state = SearchRestaurantInitial();

  String get query => _query;

  SearchRestaurantState get state => _state;

  Future<void> searchRestaurant(String query) async {
    _query = query;
    try {
      _state = SearchRestaurantLoading();
      notifyListeners();
      final response = await _apiService.getSearchRestaurant(query);
      if (response.error) {
        _state = SearchRestaurantFailure(
          message: 'Tidak ada restaurant yang ditemukan',
        );
        notifyListeners();
      } else {
        _state = SearchRestaurantSuccess(restaurants: response.restaurants);
        notifyListeners();
      }
    } on NetworkException catch (e) {
      _state = SearchRestaurantFailure(message: e.message);
      notifyListeners();
    } catch (e) {
      _state = SearchRestaurantFailure(message: e.toString());
      notifyListeners();
    }
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _state = SearchRestaurantInitial();
    notifyListeners();
  }
}
