import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/add_review_provider/add_review_provider.dart';
import 'package:restaurant_app/core/provider/detail_restaurant_provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/core/theme/app_theme.dart';
import 'package:restaurant_app/features/detail_restaurant/presentation/pages/detail_restaurant_page.dart';
import 'package:restaurant_app/features/list_restaurant/presentation/pages/list_restaurant_pages.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_provider.dart';
import 'package:restaurant_app/features/static/navigation_route.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(
          create: (context) =>
              ListRestaurantProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DetailRestaurantProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SearchRestaurantProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AddReviewProvider(context.read<ApiService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.listRestaurant.name,
      routes: {
        NavigationRoute.listRestaurant.name: (context) =>
            const ListRestaurantPages(),
        // todo-04-detail-12: dont forget to change the variable
        NavigationRoute.detailRestaurant.name: (context) =>
            DetailRestaurantPages(
              restaurantId:
                  ModalRoute.of(context)?.settings.arguments as String,
              heroTag: ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}
