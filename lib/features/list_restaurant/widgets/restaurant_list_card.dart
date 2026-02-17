import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:restaurant_app/core/model/restaurants.dart';
import 'package:restaurant_app/core/provider/local_database_provider/local_database_provider.dart'; // Import LocalDatabaseProvider
import 'package:restaurant_app/features/detail_restaurant/detail_restaurant_page.dart';

class RestaurantListCard extends StatelessWidget {
  const RestaurantListCard({super.key, required this.restaurant});

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Make onTap async
        await Navigator.push(
          // Await the push
          context,
          MaterialPageRoute(
            builder: (context) => DetailRestaurantPages(
              restaurantId: restaurant.id,
              heroTag: 'list-${restaurant.pictureId}',
            ),
          ),
        );
        // After returning from DetailRestaurantPages, force refresh the favorite list
        // This assumes LocalDatabaseProvider is available in the widget tree above RestaurantListCard
        // ignore: use_build_context_synchronously
        context.read<LocalDatabaseProvider>().getRestaurantList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                  child: SizedBox(
                    height: 100,
                    child: Hero(
                      tag: 'list-${restaurant.pictureId}',
                      child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.city,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(restaurant.rating.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
