import 'package:flutter/material.dart';

class FavoriteRestaurantPage extends StatefulWidget {
  const FavoriteRestaurantPage({super.key});

  @override
  State<FavoriteRestaurantPage> createState() => _FavoriteRestaurantPageState();
}

class _FavoriteRestaurantPageState extends State<FavoriteRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurant"),
      ),
      body: const Center(
        child: Text("This is Favorite Restaurant Page"),
      ),
    );
  }
}