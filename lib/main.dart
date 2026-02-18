import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/provider/add_review_provider/add_review_provider.dart';
import 'package:restaurant_app/core/provider/detail_restaurant_provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/local_database_provider/local_database_provider.dart';
import 'package:restaurant_app/core/provider/theme_provider/theme_provicder.dart';
import 'package:restaurant_app/core/provider/reminder_provider/reminder_provider.dart'; // Added
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/core/service/local_database_service.dart';
import 'package:restaurant_app/core/service/local_notification_service.dart'; // Added
import 'package:restaurant_app/core/theme/app_theme.dart';
import 'package:restaurant_app/features/detail_restaurant/detail_restaurant_page.dart';
import 'package:restaurant_app/features/favorite_restaurant/favorite_restaurant_page.dart';
import 'package:restaurant_app/features/list_restaurant/pages/list_restaurant_pages.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
import 'package:restaurant_app/core/provider/search_restaurant_provider/search_restaurant_provider.dart';
import 'package:restaurant_app/features/static/navigation_route.dart';

void main() async { // Changed to async
  WidgetsFlutterBinding.ensureInitialized(); // Added
  final LocalNotificationService localNotificationService = LocalNotificationService(); // Added
  await localNotificationService.init(); // Added
  await localNotificationService.configureLocalTimeZone(); // Added
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        Provider(create: (context) => LocalDatabaseService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<LocalDatabaseService>()),
        ),
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
        ChangeNotifierProvider(create: (context) => ReminderProvider()), // Added
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Restaurant App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
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
            NavigationRoute.favoriteRestaurant.name: (context) =>
                const FavoriteRestaurantPage(),
          },
        );
      },
    );
  }
}
