import 'package:restaurant_app/core/model/customer_reviews.dart';

class AddReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReviews>? customerReviews;

  AddReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) {
    return AddReviewResponse(
      error: json['error'],
      message: json['message'],
      customerReviews: (json['customerReviews'] as List<dynamic>?)
          ?.map((e) => CustomerReviews.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
