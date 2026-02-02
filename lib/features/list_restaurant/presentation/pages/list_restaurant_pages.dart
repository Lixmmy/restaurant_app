import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_state.dart';
import 'package:restaurant_app/features/detail_restaurant/presentation/pages/detail_restaurant_page.dart';
import 'package:restaurant_app/features/list_restaurant/presentation/widgets/restaurant_grid_card.dart';
import 'package:restaurant_app/features/list_restaurant/presentation/widgets/restaurant_list_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListRestaurantPages extends StatelessWidget {
  const ListRestaurantPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search restaurant",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<ListRestaurantProvider>(
              builder: (context, provider, child) {
                final state = provider.state;
                if (state is ListRestaurantLoading ||
                    state is ListRestaurantInitial) {
                  return Skeletonizer(
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(height: 200, color: Colors.grey),
                    ),
                  );
                } else if (state is ListRestaurantFailure) {
                  return Center(child: Text(state.message));
                } else if (state is ListRestaurantSuccess) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: CarouselSlider(
                        items: state.restaurants.map((restaurant) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRestaurantPages(
                                    restaurantId: restaurant.id,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: restaurant.pictureId,
                              child: Image.network(
                                "https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text(""));
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recommendation",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Recommendation restaurant for you!",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Consumer<ListRestaurantProvider>(
              builder: (context, provider, child) {
                final state = provider.state;
                if (state is ListRestaurantLoading ||
                    state is ListRestaurantInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ListRestaurantFailure) {
                  return Center(child: Text(state.message));
                } else if (state is ListRestaurantSuccess) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 800) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 3 / 4,
                              ),
                          itemCount: state.restaurants.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final restaurant = state.restaurants[index];
                            return RestaurantGridCard(restaurant: restaurant);
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: state.restaurants.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final restaurant = state.restaurants[index];
                            return RestaurantListCard(restaurant: restaurant);
                          },
                        );
                      }
                    },
                  );
                } else {
                  return const Center(child: Text(""));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
