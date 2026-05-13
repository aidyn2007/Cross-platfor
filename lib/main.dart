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

class Yummy extends ConsumerStatefulWidget {
  const Yummy({super.key});

  @override
  ConsumerState<Yummy> createState() => _YummyState();
}

class _YummyState extends ConsumerState<Yummy> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.deepPurple;

  final CartManager _cartManager = CartManager();
  final OrderManager _orderManager = OrderManager();

  late final UserDao _userDao;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _userDao = ref.read(userDaoProvider);
    _router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _userDao,
      redirect: _appRedirect,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
            path: '/:tab',
            builder: (context, state) {
              return Home(
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
                  path: 'bookstore/:id',
                  builder: (context, state) {
                    final id =
                        int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    final bookstore = bookstores[id];
                    return BookstorePage(
                      bookstore: bookstore,
                      cartManager: _cartManager,
                      ordersManager: _orderManager,
                    );
                  }),
            ]),
      ],
    );
  }

  String? _appRedirect(BuildContext context, GoRouterState state) {
    final loggedIn = _userDao.isLoggedIn();
    final isOnLoginPage = state.matchedLocation == '/login';

    if (!loggedIn) {
      return isOnLoginPage ? null : '/login';
    }
    if (isOnLoginPage) {
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
