import 'package:restaurant_app/core/model/customer_reviews.dart';

sealed class AddReviewState {}

class AddReviewInitial extends AddReviewState {}

class AddReviewLoading extends AddReviewState {}

class AddReviewSuccess extends AddReviewState {
  final List<CustomerReviews> customerReviews;

  AddReviewSuccess({required this.customerReviews});
}

class AddReviewFailure extends AddReviewState {
  final String message;

  AddReviewFailure({required this.message});
}
