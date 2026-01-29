import 'package:flutter/material.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/features/provider/add_review_provider/add_review_state.dart';

class AddReviewProvider extends ChangeNotifier {
  final ApiService _apiService;

  AddReviewProvider(this._apiService);

  AddReviewState _state = AddReviewInitial();

  AddReviewState get state => _state;

  Future<void> addReview(List<Map<String, dynamic>> body) async {
    try {
      _state = AddReviewLoading();
      notifyListeners();
      final response = await _apiService.addReview(body);
      if (response.error) {
        _state = AddReviewFailure(message: response.message);
        notifyListeners();
      } else {
        _state = AddReviewSuccess(customerReviews: response.customerReviews!);
        notifyListeners();
      }
    } catch (e) {
      _state = AddReviewFailure(message: e.toString());
      notifyListeners();
    }
  }
}
