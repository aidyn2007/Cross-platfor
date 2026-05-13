import 'package:flutter/material.dart';
import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExplorePage extends StatefulWidget {
  final CartManager cartManager;
  final OrderManager orderManager;
  final ValueChanged<String> onSearchBooks;

  const ExplorePage({
    super.key,
    required this.cartManager,
    required this.orderManager,
    required this.onSearchBooks,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final mockService = MockYummyService();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    if (query.length >= 3) {
      widget.onSearchBooks(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final bookstores = snapshot.data?.bookstores ?? [];
          final categories = snapshot.data?.categories ?? [];
          final posts = snapshot.data?.friendPosts ?? [];

          return CustomScrollView(
            slivers: [
              // Шапка с вашим изображением
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/book_store_header.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What would you like to read today?',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Search for books or genres...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: _submitSearch,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.5),
                        ),
                        onSubmitted: (_) => _submitSearch(),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BookstoreSection(
                  bookstores: bookstores,
                  cartManager: widget.cartManager,
                  orderManager: widget.orderManager,
                ),
              ),
              SliverToBoxAdapter(
                child: PostSection(posts: posts),
              ),
              SliverToBoxAdapter(
                child: CategorySection(categories: categories),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
