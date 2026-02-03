import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/add_review_provider/add_review_provider.dart';
import 'package:restaurant_app/core/provider/detail_restaurant_provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/detail_restaurant_provider/detail_restaurant_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailRestaurantPages extends StatefulWidget {
  final String restaurantId;
  final String heroTag;

  const DetailRestaurantPages({
    super.key,
    required this.restaurantId,
    required this.heroTag,
  });

  @override
  State<DetailRestaurantPages> createState() => _DetailRestaurantPagesState();
}

class _DetailRestaurantPagesState extends State<DetailRestaurantPages> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetailRestaurantProvider>(
        context,
        listen: false,
      ).getDetailRestaurant(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: false,
            floating: true,
            title: Consumer<DetailRestaurantProvider>(
              builder: (context, provider, child) {
                final state = provider.state;
                if (state is DetailRestaurantSuccess) {
                  return Text(
                    state.restaurant.name,
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return Text("");
                }
              },
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Consumer<DetailRestaurantProvider>(
                builder: (context, provider, child) {
                  final state = provider.state;
                  if (state is DetailRestaurantLoading ||
                      state is DetailRestaurantInitial) {
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        height: 200,
                        color: Colors.grey.shade200,
                      ),
                    );
                  } else if (state is DetailRestaurantFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is DetailRestaurantSuccess) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Hero(
                        tag: widget.heroTag,
                        child: Image.network(
                          "https://restaurant-api.dicoding.dev/images/large/${state.restaurant.pictureId}",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text(""));
                  }
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<DetailRestaurantProvider>(
              builder: (context, provider, child) {
                final state = provider.state;
                if (state is DetailRestaurantLoading ||
                    state is DetailRestaurantInitial) {
                  return Skeletonizer(
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  );
                } else if (state is DetailRestaurantSuccess) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.restaurant.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_city),
                              Text(
                                state.restaurant.address,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              Text(
                                state.restaurant.rating.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            state.restaurant.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          Divider(),
                          Row(
                            children: [
                              Icon(Icons.adjust_sharp, color: Colors.red),
                              Text(
                                state.restaurant.categories
                                    .map((e) => e.name)
                                    .join(", "),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text(""));
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<DetailRestaurantProvider>(
              builder: (context, provider, child) {
                final state = provider.state;
                if (state is DetailRestaurantSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Menu",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Text("Foods"),
                        MediaQuery.of(context).size.width < 600
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.restaurant.menus.foods.length,
                                itemBuilder: (context, index) {
                                  final food =
                                      state.restaurant.menus.foods[index];
                                  return Card(
                                    child: ListTile(title: Text(food.name)),
                                  );
                                },
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width <
                                              1200
                                          ? 4
                                          : 8,
                                    ),
                                itemCount: state.restaurant.menus.foods.length,
                                itemBuilder: (context, index) {
                                  final food =
                                      state.restaurant.menus.foods[index];
                                  return Card(
                                    child: ListTile(title: Text(food.name)),
                                  );
                                },
                              ),
                        Text("Drinks"),
                        MediaQuery.of(context).size.width < 600
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.restaurant.menus.drinks.length,
                                itemBuilder: (context, index) {
                                  final drink =
                                      state.restaurant.menus.drinks[index];
                                  return Card(
                                    child: ListTile(title: Text(drink.name)),
                                  );
                                },
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width <
                                              1200
                                          ? 4
                                          : 8,
                                    ),
                                itemCount: state.restaurant.menus.drinks.length,
                                itemBuilder: (context, index) {
                                  final drink =
                                      state.restaurant.menus.drinks[index];
                                  return Card(
                                    child: ListTile(title: Text(drink.name)),
                                  );
                                },
                              ),

                        SizedBox(height: 16),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text(""));
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<DetailRestaurantProvider>(
              builder: (context, provider, child) {
                final state = provider.state;
                if (state is DetailRestaurantSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reviews",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height:
                              150, // Added fixed height for horizontal scrolling
                          child: GridView.builder(
                            scrollDirection:
                                Axis.horizontal, // Changed to horizontal scroll
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      1, // One row for horizontal scroll
                                  childAspectRatio:
                                      1.0, // Aspect ratio of each item
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            // Removed NeverScrollableScrollPhysics to allow scrolling
                            shrinkWrap: true,
                            itemCount: state.restaurant.customerReviews.length,
                            itemBuilder: (context, index) {
                              final review =
                                  state.restaurant.customerReviews[index];
                              return Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(review.name),
                                    Text(review.review),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text(""));
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<AddReviewProvider>(
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: "Name"),
                              ),
                              TextField(
                                controller: _reviewController,
                                decoration: InputDecoration(
                                  labelText: "Review",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AddReviewProvider>().addReview(
                                    widget.restaurantId,
                                    _nameController.text,
                                    _reviewController.text,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text("Add Review"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text("Add Review"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
