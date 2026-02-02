enum NavigationRoute {
  listRestaurant("/list_restaurant"),
  detailRestaurant("/detail_restaurant");

  final String name;

  const NavigationRoute(this.name);
}
