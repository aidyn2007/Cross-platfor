import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'models/models.dart';
import 'network/google_books_service.dart';
import 'providers.dart';
import 'screens/screens.dart';

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
      child: const BooksApp(),
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

class BooksApp extends ConsumerStatefulWidget {
  const BooksApp({super.key});

  @override
  ConsumerState<BooksApp> createState() => _BooksAppState();
}

class _BooksAppState extends ConsumerState<BooksApp> {
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
          pageBuilder: (context, state) => _buildPage(
            state,
            const LoginPage(),
            beginOffset: const Offset(0, 0.04),
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => _buildPage(
            state,
            const LoginPage(isRegister: true),
            beginOffset: const Offset(0, 0.04),
          ),
        ),
        GoRoute(
            path: '/:tab',
            pageBuilder: (context, state) {
              final tabIndex =
                  int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
              return _buildPage(
                state,
                Home(
                  cartManager: _cartManager,
                  ordersManager: _orderManager,
                  changeTheme: changeThemeMode,
                  changeColor: changeColor,
                  colorSelected: colorSelected,
                  tab: tabIndex,
                  initialBookSearchQuery: state.uri.queryParameters['search'],
                ),
              );
            },
            routes: [
              GoRoute(
                  path: 'bookstore/:id',
                  pageBuilder: (context, state) {
                    final id =
                        int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                    final bookstore = bookstores[id];
                    return _buildPage(
                      state,
                      BookstorePage(
                        bookstore: bookstore,
                        cartManager: _cartManager,
                        ordersManager: _orderManager,
                      ),
                      beginOffset: const Offset(0.08, 0),
                    );
                  }),
              GoRoute(
                path: 'personal-info',
                pageBuilder: (context, state) => _buildPage(
                  state,
                  const PersonalInfoPage(),
                  beginOffset: const Offset(0.08, 0),
                ),
              ),
            ]),
      ],
    );
  }

  CustomTransitionPage<void> _buildPage(
    GoRouterState state,
    Widget child, {
    Offset beginOffset = const Offset(0.06, 0),
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  String? _appRedirect(BuildContext context, GoRouterState state) {
    final loggedIn = _userDao.isLoggedIn();
    final isOnAuthPage = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!loggedIn) {
      return isOnAuthPage ? null : '/login';
    }
    if (isOnAuthPage) {
      return '/${BooksTab.home.value}';
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
      title: 'Books',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      themeMode: themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
    );
  }
}
