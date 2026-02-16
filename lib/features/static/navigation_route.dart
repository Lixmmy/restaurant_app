enum NavigationRoute {
  listRestaurant("/list_restaurant"),
  detailRestaurant("/detail_restaurant"),
  favoriteRestaurant("/favorite_restaurant");

  final String name;

  const NavigationRoute(this.name);
}
