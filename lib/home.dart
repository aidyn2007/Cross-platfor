import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:books/constants.dart';
import 'package:books/components/components.dart';
import 'package:books/models/models.dart';
import 'package:books/screens/screens.dart';
import 'package:books/providers.dart';
import 'package:books/ui/library/library_page.dart';
import 'package:books/ui/recipes/book_list.dart';
import 'package:books/screens/chat_page.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
    required this.cartManager,
    required this.ordersManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
    this.initialBookSearchQuery,
  });

  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final String? initialBookSearchQuery;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Explore',
      selectedIcon: Icon(Icons.home),
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      label: 'Book Finder',
      selectedIcon: Icon(Icons.search),
    ),
    NavigationDestination(
      icon: Icon(Icons.local_library_outlined),
      label: 'Library List',
      selectedIcon: Icon(Icons.local_library),
    ),
    NavigationDestination(
      icon: Icon(Icons.list_outlined),
      label: 'Orders',
      selectedIcon: Icon(Icons.list),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Account',
      selectedIcon: Icon(Icons.person),
    ),
    NavigationDestination(
      icon: Icon(Icons.question_answer_outlined),
      label: 'Chat',
      selectedIcon: Icon(Icons.question_answer),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
        onSearchBooks: (query) {
          context.go('/1?search=${Uri.encodeQueryComponent(query)}');
        },
      ),
      BookList(initialSearchQuery: widget.initialBookSearchQuery),
      const LibraryPage(),
      MyOrdersPage(orderManager: widget.ordersManager),
      AccountPage(
          user: User(
              firstName: ref.watch(userDaoProvider).email() ?? 'Reader',
              lastName: '',
              role: 'Books Enthusiast',
              profileImageUrl: 'assets/profile_pics/person_stef.jpeg',
              points: 100,
              darkMode: true)),
      const ChatPage(),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.surface,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            ThemeButton(
              changeThemeMode: widget.changeTheme,
            ),
            ColorButton(
              changeColor: widget.changeColor,
              colorSelected: widget.colorSelected,
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 360),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          child: IndexedStack(
            key: ValueKey<int>(widget.tab),
            index: widget.tab,
            children: pages,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.tab,
          onDestinationSelected: (index) {
            context.go('/$index');
          },
          destinations: appBarDestinations,
        ),
      ),
    );
  }
}
