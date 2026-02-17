import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/provider/favorite_icon_provider/favorite_icon_provider.dart';

class FavoriteIcons extends StatefulWidget {
  final Restaurants restaurant;
  const FavoriteIcons({super.key, required this.restaurant});

  @override
  State<FavoriteIcons> createState() => _FavoriteIconsState();
}

class _FavoriteIconsState extends State<FavoriteIcons> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<FavoriteIconProvider>().toggleFavorite();
      },
      icon: Consumer<FavoriteIconProvider>(
        builder: (context, provider, child) {
          return Icon(
            context.watch<FavoriteIconProvider>().isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
          );
        },
      ),
    );
  }
}
