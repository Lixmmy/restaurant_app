import 'package:restaurant_app/core/model/drink.dart';
import 'package:restaurant_app/core/model/food.dart';

class Menus {
  final List<Food> foods;
  final List<Drink> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List<dynamic>)
          .map((e) => Food.fromJson(e as Map<String, dynamic>))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((e) => Drink.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
