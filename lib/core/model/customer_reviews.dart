class CustomerReviews {
  final String name;
  final String review;
  final String date;

  CustomerReviews({
    required this.name,
    required this.review,
    required this.date,
  });
  factory CustomerReviews.fromJson(Map<String, dynamic> json) {
    return CustomerReviews(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'review': review, 'date': date};
  }
}
