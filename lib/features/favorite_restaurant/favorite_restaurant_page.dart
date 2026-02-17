import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/local_database_provider/local_database_provider.dart';
import 'package:restaurant_app/features/list_restaurant/widgets/restaurant_list_card.dart';

class FavoriteRestaurantPage extends StatefulWidget {
  const FavoriteRestaurantPage({super.key});

  @override
  State<FavoriteRestaurantPage> createState() => _FavoriteRestaurantPageState();
}

class _FavoriteRestaurantPageState extends State<FavoriteRestaurantPage> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      context.read<LocalDatabaseProvider>().getRestaurantList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Restaurant")),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, provider, child) {
          final restaurants = provider.restaurants;
          final message = provider.message;

          if (restaurants == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (restaurants.isEmpty) {
            return Center(child: Text(message));
          }

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantListCard(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}
