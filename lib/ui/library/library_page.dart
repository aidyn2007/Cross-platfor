import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../data/models/recipe.dart';
import '../../providers.dart';
import '../recipes/recipe_details.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  late Stream<List<Recipe>> _recipeStream;

  @override
  void initState() {
    super.initState();
    _recipeStream = ref.read(repositoryProvider.notifier).watchAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, colorScheme)),
          StreamBuilder<List<Recipe>>(
            stream: _recipeStream,
            builder: (context, snapshot) {
              final books = snapshot.data ?? [];

              if (books.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No saved books yet')),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                sliver: SliverList.separated(
                  itemCount: books.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildBookTile(context, books[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 132,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.45),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_library_outlined,
            color: colorScheme.primary,
            size: 48,
          ),
          const SizedBox(width: 16),
          Text(
            'Library List',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookTile(BuildContext context, Recipe book) {
    return Slidable(
      key: ValueKey(book.sourceId ?? book.id ?? book.label),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            icon: Icons.delete_outline,
            onPressed: (context) {
              ref.read(repositoryProvider.notifier).deleteRecipe(book);
            },
          ),
        ],
      ),
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: _buildCover(book.image),
          ),
          title: Text(
            book.label ?? 'Untitled',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecipeDetails(recipe: book.copyWith(bookmarked: true)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCover(String? imageUrl) {
    const width = 56.0;
    const height = 76.0;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildCoverFallback(width, height);
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => _buildCoverFallback(width, height),
    );
  }

  Widget _buildCoverFallback(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.book_outlined),
    );
  }
}
