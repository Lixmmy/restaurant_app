import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_state.dart';
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
                  return CarouselSlider(
                    items: state.restaurants.map((restaurant) {
                      return Hero(
                        tag: restaurant.pictureId,
                        child: Image.network(
                          "https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
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
                  return Center(child: CircularProgressIndicator());
                } else if (state is ListRestaurantFailure) {
                  return Center(child: Text(state.message));
                } else if (state is ListRestaurantSuccess) {
                  return ListView.builder(
                    itemCount: state.restaurants.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
                      return ListTile(
                        title: Text(restaurant.name),
                        subtitle: Text(restaurant.city),
                        leading: Hero(
                          tag: restaurant.pictureId,
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text(""));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
