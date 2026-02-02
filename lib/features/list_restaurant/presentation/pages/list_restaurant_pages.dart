import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_state.dart'
    as list_state;
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_state.dart'
    as search_state;
import 'package:restaurant_app/features/detail_restaurant/presentation/pages/detail_restaurant_page.dart';
import 'package:restaurant_app/features/list_restaurant/presentation/widgets/restaurant_grid_card.dart';
import 'package:restaurant_app/features/list_restaurant/presentation/widgets/restaurant_list_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListRestaurantPages extends StatefulWidget {
  const ListRestaurantPages({super.key});

  @override
  State<ListRestaurantPages> createState() => _ListRestaurantPagesState();
}

class _ListRestaurantPagesState extends State<ListRestaurantPages> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                    if (value.isNotEmpty) {
                      context.read<SearchRestaurantProvider>().searchRestaurant(
                        value,
                      );
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search restaurant",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
            // Conditionally display search results or default content
            _searchController.text.isEmpty
                ? const _DefaultContent()
                : _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, provider, child) {
        final state = provider.state;
        if (state is search_state.SearchRestaurantLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is search_state.SearchRestaurantFailure) {
          return Center(child: Text(state.message));
        } else if (state is search_state.SearchRestaurantSuccess) {
          if (state.restaurants.isEmpty) {
            return const Center(child: Text('No restaurants found.'));
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 800) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          return const Center(child: Text("Search for a restaurant"));
        }
      },
    );
  }
}

class _DefaultContent extends StatelessWidget {
  const _DefaultContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Consumer<ListRestaurantProvider>(
          builder: (context, provider, child) {
            final state = provider.state;
            if (state is list_state.ListRestaurantLoading ||
                state is list_state.ListRestaurantInitial) {
              return Skeletonizer(
                enabled: true,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(height: 200, color: Colors.grey),
                ),
              );
            } else if (state is list_state.ListRestaurantFailure) {
              return Center(child: Text(state.message));
            } else if (state is list_state.ListRestaurantSuccess) {
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
              return const Center(child: Text(""));
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
            if (state is list_state.ListRestaurantLoading ||
                state is list_state.ListRestaurantInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is list_state.ListRestaurantFailure) {
              return Center(child: Text(state.message));
            } else if (state is list_state.ListRestaurantSuccess) {
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
    );
  }
}
