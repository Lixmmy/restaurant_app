import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/service/api_service.dart';
import 'package:restaurant_app/core/theme/app_theme.dart';
import 'package:restaurant_app/features/list_restaurant/presentation/pages/list_restaurant_pages.dart';
import 'package:restaurant_app/core/provider/list_restaurant_provider/list_restaurant_provider.dart';
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
      title: 'Tourism App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.listRestaurant.name,
      routes: {
        NavigationRoute.listRestaurant.name: (context) =>
            const ListRestaurantPages(),
        // // todo-04-detail-12: dont forget to change the variable
        // NavigationRoute.detailRoute.name: (context) => DetailScreen(
        //       tourismId: ModalRoute.of(context)?.settings.arguments as int,
        //     ),
      },
    );
  }
}
