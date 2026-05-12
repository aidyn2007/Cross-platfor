import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'screens/screens.dart';
import 'models/models.dart';
import 'home.dart';
import 'providers.dart';
import 'network/google_books_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  final service = GoogleBooksService.create();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefProvider.overrideWithValue(sharedPrefs),
        serviceProvider.overrideWithValue(service),
      ],
      child: const Yummy(),
    ),
  );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad
      };
}

class Yummy extends StatefulWidget {
  const Yummy({super.key});

  @override
  State<Yummy> createState() => _YummyState();
}

class _YummyState extends State<Yummy> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.deepPurple;

  final YummyAuth _auth = YummyAuth();
  final CartManager _cartManager = CartManager();
  final OrderManager _orderManager = OrderManager();

  late final _router = GoRouter(
    initialLocation: '/login',
    redirect: _appRedirect,
    routes: [
      GoRoute(
          path: '/login',
          builder: (context, state) =>
              LoginPage(onLogIn: (Credentials credentials) async {
                _auth
                    .signIn(credentials.username, credentials.password)
                    .then((_) => context.go('/${YummyTab.home.value}'));
              })),
      GoRoute(
          path: '/:tab',
          builder: (context, state) {
            return Home(
              auth: _auth,
              cartManager: _cartManager,
              ordersManager: _orderManager,
              changeTheme: changeThemeMode,
              changeColor: changeColor,
              colorSelected: colorSelected,
              tab: int.tryParse(state.pathParameters['tab'] ?? '') ?? 0,
              initialBookSearchQuery: state.uri.queryParameters['search'],
            );
          },
          routes: [
            GoRoute(
                path: 'restaurant/:id',
                builder: (context, state) {
                  final id =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  final restaurant = restaurants[id];
                  return RestaurantPage(
                    restaurant: restaurant,
                    cartManager: _cartManager,
                    ordersManager: _orderManager,
                  );
                }),
          ]),
    ],
  );

  Future<String?> _appRedirect(
      BuildContext context, GoRouterState state) async {
    final loggedIn = await _auth.loggedIn;
    final isOnLoginPage = state.matchedLocation == '/login';

    if (!loggedIn) {
      return '/login';
    } else if (loggedIn && isOnLoginPage) {
      return '/${YummyTab.home.value}';
    }

    return null;
  }

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF673AB7),
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      themeMode: themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
    );
  }
}
