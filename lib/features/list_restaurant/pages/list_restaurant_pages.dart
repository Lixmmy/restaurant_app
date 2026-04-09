import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_state.dart'
    as list_state;
import 'package:restaurant_app/core/provider/reminder_provider/reminder_provider.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_state.dart'
    as search_state;
import 'package:restaurant_app/core/provider/theme_provider/theme_provicder.dart';
import 'package:restaurant_app/features/detail_restaurant/detail_restaurant_page.dart';
import 'package:restaurant_app/features/favorite_restaurant/favorite_restaurant_page.dart';
import 'package:restaurant_app/features/list_restaurant/widgets/restaurant_grid_card.dart';
import 'package:restaurant_app/features/list_restaurant/widgets/restaurant_list_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListRestaurantPages extends StatefulWidget {
  const ListRestaurantPages({super.key});

  @override
  State<ListRestaurantPages> createState() => _ListRestaurantPagesState();
}

class _ListRestaurantPagesState extends State<ListRestaurantPages> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListRestaurantProvider>().getListRestaurant();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant App")),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoriteRestaurantPage(),
                  ),
                );
              },
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Theme'),
                  trailing: Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme(value);
                    },
                  ),
                );
              },
            ),
            Consumer<ReminderProvider>(
              builder: (context, reminderProvider, child) {
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Reminder'),
                  trailing: Switch(
                    value: reminderProvider.isReminderEnabled,
                    onChanged: (value) {
                      reminderProvider.toggleReminder(value);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Restaurant App',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.restaurant),
                  children: [
                    const Text('This app is a restaurant listing app.'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<SearchRestaurantProvider>(
        builder: (context, searchProvider, child) {
          return SingleChildScrollView(
            child: SafeArea(
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
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 500),
                            () {
                              if (value.isNotEmpty) {
                                context
                                    .read<SearchRestaurantProvider>()
                                    .searchRestaurant(value);
                              } else {
                                context
                                    .read<SearchRestaurantProvider>()
                                    .clearSearch();
                              }
                            },
                          );
                          context.read<SearchRestaurantProvider>().setQuery(
                            value,
                          );
                        },
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Search restaurant",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchProvider.query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<SearchRestaurantProvider>()
                                        .clearSearch();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  // Conditionally display search results or default content
                  searchProvider.query.isEmpty
                      ? const _DefaultContent()
                      : _buildSearchResults(),
                ],
              ),
            ),
          );
        },
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
                                heroTag: 'carousel-${restaurant.pictureId}',
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'carousel-${restaurant.pictureId}',
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
