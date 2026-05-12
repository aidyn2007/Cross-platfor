import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/recipe.dart';
import '../models/models.dart';
import '../providers.dart';

class BookDetailsPage extends ConsumerStatefulWidget {
  final FoodCategory category;

  const BookDetailsPage({super.key, required this.category});

  @override
  ConsumerState<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends ConsumerState<BookDetailsPage>
    with SingleTickerProviderStateMixin {
  static const _description =
      'This is a captivating story that explores deep themes of human nature '
      'and society. A must-read for anyone who loves immersive storytelling.';

  late AnimationController _controller;
  late Animation<double> _alignmentAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _alignmentAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.2),
              colorScheme.surface,
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                // Обложка книги
                Align(
                  alignment: Alignment(_alignmentAnimation.value, -0.4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Hero(
                      tag: 'book-image-${widget.category.name}',
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(5, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.category.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Информация о книге
                Align(
                  alignment: const Alignment(0.8, -0.3),
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Genre: Literary Fiction',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _description,
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _addToLibrary,
                            icon: const Icon(Icons.bookmark_add_outlined),
                            label: const Text('Add to Library'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _addToLibrary() {
    final book = Recipe(
      id: widget.category.name.hashCode,
      label: widget.category.name,
      image: widget.category.imageUrl,
      description: _description,
      bookmarked: true,
    );

    ref.read(repositoryProvider.notifier).insertRecipe(book);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.category.name} added to library')),
    );
  }
}
