import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:books/components/components.dart';
import '../../providers.dart';
import '../../data/models/book.dart';
import '../../network/model_response.dart';
import '../theme/colors.dart';
import '../widgets/common.dart';

class BookView extends ConsumerStatefulWidget {
  final Book book;

  const BookView({
    super.key,
    required this.book,
  });

  @override
  ConsumerState<BookView> createState() => _BookViewState();
}

class _BookViewState extends ConsumerState<BookView> {
  Book? bookDetail;

  @override
  void initState() {
    super.initState();
    loadBook();
  }

  void loadBook() async {
    if (widget.book.sourceId == null) {
      bookDetail = widget.book;
      return;
    }

    final bookId = widget.book.sourceId ?? widget.book.id.toString();
    final response = await ref.read(serviceProvider).queryBook(bookId);
    final result = response.body;
    if (result is Success<Book>) {
      final body = result.value;
      if (mounted) {
        setState(() {
          bookDetail = body;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.label ?? 'Details'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: maxHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                topImage(context),
                sizedW16,
                AnimatedSlideFade(
                  delay: const Duration(milliseconds: 120),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        titleRow(),
                        description(),
                        sizedW16,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: 150,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.5, 1.0],
                  colors: [lightGreen, Colors.white, lightGreen]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Hero(
            tag: 'book-${widget.book.id}',
            child: _buildBookImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookImage() {
    final image = widget.book.image ?? '';

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        alignment: Alignment.topCenter,
        fit: BoxFit.contain,
        height: 150,
        width: 200,
      );
    }

    return CachedNetworkImage(
      imageUrl: image,
      alignment: Alignment.topCenter,
      fit: BoxFit.contain,
      placeholder: (context, url) => const AnimatedBookLoader(
        message: 'Loading cover...',
        size: 96,
      ),
      height: 150,
      width: 200,
    );
  }

  Widget titleRow() {
    final repository = ref.read(repositoryProvider.notifier);
    final bookmarked = widget.book.bookmarked;
    const titleRowColor = Colors.black;
    return Container(
      decoration: const BoxDecoration(color: lightGreen),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                widget.book.label ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 24, color: titleRowColor),
              ),
            ),
            IconButton(
              icon: Icon(
                bookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: titleRowColor,
              ),
              onPressed: () {
                final selectedBook = (bookDetail ?? widget.book).copyWith(
                  bookmarked: true,
                );
                if (!bookmarked) {
                  repository.insertBook(selectedBook);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${selectedBook.label ?? 'Book'} added to library'),
                    ),
                  );
                } else {
                  repository.deleteBook(selectedBook);
                }
                Navigator.pop(context);
              },
            ),
            sizedW8,
          ],
        ),
      ),
    );
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: bookDetail?.description == null
            ? const AnimatedBookLoader(
                key: ValueKey('description-loading'),
                message: 'Loading description...',
                size: 96,
              )
            : Html(
                key: const ValueKey('description-loaded'),
                data: bookDetail!.description!,
              ),
      ),
    );
  }
}
