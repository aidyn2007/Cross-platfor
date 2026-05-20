import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/components.dart';
import '../../data/models/models.dart';
import '../../network/model_response.dart';
import '../../network/query_result.dart';
import '../../network/service_interface.dart';
import '../../providers.dart';
import '../book_card.dart';
import '../bookmarks/bookmarks.dart';
import '../theme/colors.dart';
import '../widgets/custom_dropdown.dart';
import 'book_view.dart';

enum ListType { all, bookmarks }

class BookList extends ConsumerStatefulWidget {
  final String? initialSearchQuery;

  const BookList({
    super.key,
    this.initialSearchQuery,
  });

  @override
  ConsumerState createState() => _BookListState();
}

class _BookListState extends ConsumerState<BookList> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List<Book> currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];
  ListType currentType = ListType.all;
  Future<BookResponse>? currentResponse;
  bool newDataRequired = true;

  @override
  void initState() {
    super.initState();
    getPreviousSearches();
    searchTextController = TextEditingController(
      text: widget.initialSearchQuery?.trim() ?? '',
    );
    _scrollController.addListener(() {
      if (currentType == ListType.all) {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;
        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
            setState(() {
              loading = true;
              newDataRequired = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant BookList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextQuery = widget.initialSearchQuery?.trim() ?? '';
    final oldQuery = oldWidget.initialSearchQuery?.trim() ?? '';

    if (nextQuery.isNotEmpty &&
        nextQuery != oldQuery &&
        nextQuery != searchTextController.text.trim()) {
      searchTextController.text = nextQuery;
      startSearch(nextQuery);
    }
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void savePreviousSearches() {
    final prefs = ref.read(sharedPrefProvider);
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() {
    final prefs = ref.read(sharedPrefProvider);
    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);
      previousSearches = searches ?? <String>[];
    }
  }

  void startSearch(String value) {
    setState(() {
      currentSearchList.clear();
      newDataRequired = true;
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = false;
      currentResponse = null;
      final trimmed = value.trim();
      if (trimmed.isNotEmpty && !previousSearches.contains(trimmed)) {
        previousSearches.add(trimmed);
        savePreviousSearches();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (currentType) {
      ListType.all => buildBookList(),
      ListType.bookmarks => buildBookmarkList()
    };
  }

  Widget buildBookList() {
    return buildScrollList([
      _buildTypePicker(),
      _buildSearchCard(),
    ], _buildBookLoader(context));
  }

  Widget buildBookmarkList() {
    return buildScrollList([
      _buildTypePicker(),
    ], const Bookmarks());
  }

  Widget buildScrollList(List<Widget> topList, Widget bottomWidget) {
    return Column(
      children: [
        ...topList,
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: bottomWidget,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return AnimatedSlideFade(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              AnimatedTapScale(
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    startSearch(searchTextController.text);
                    final currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  controller: searchTextController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for books online...',
                  ),
                  onSubmitted: startSearch,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => searchTextController.clear()),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: lightGrey,
                ),
                onSelected: (String value) {
                  searchTextController.text = value;
                  startSearch(searchTextController.text);
                },
                itemBuilder: (BuildContext context) {
                  return previousSearches
                      .map<CustomDropdownMenuItem<String>>((String value) {
                    return CustomDropdownMenuItem<String>(
                      text: value,
                      value: value,
                      callback: () {
                        setState(() {
                          previousSearches.remove(value);
                          savePreviousSearches();
                          Navigator.pop(context);
                        });
                      },
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return const SliverFillRemaining(
          child: Center(child: Text('Type at least 3 characters to search')));
    }
    return FutureBuilder<BookResponse>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            newDataRequired = false;
            return _buildSearchError(snapshot.error.toString());
          }

          loading = false;
          final response = snapshot.data;
          if (response == null) {
            inErrorState = true;
            newDataRequired = false;
            return _buildSearchError('Could not load books. Try again.');
          }

          if (!response.isSuccessful || response.error != null) {
            inErrorState = true;
            newDataRequired = false;
            return _buildSearchError(_errorMessage(response.error));
          }

          final result = response.body;
          if (result is Error) {
            inErrorState = true;
            newDataRequired = false;
            return _buildSearchError(_errorMessage(result));
          }

          if (result == null) {
            inErrorState = true;
            newDataRequired = false;
            return _buildSearchError('Could not read the book search results.');
          }

          final query = (result as Success<QueryResult>).value;
          inErrorState = false;
          currentCount = query.totalResults;
          hasMore = query.totalResults > (query.offset + query.number);
          if (newDataRequired) {
            currentSearchList.addAll(query.books);
            newDataRequired = false;
          }
          return currentSearchList.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('No Results')))
              : _buildBookList(context, currentSearchList);
        } else {
          return currentCount == 0
              ? const SliverFillRemaining(
                  child: Center(
                    child: AnimatedBookLoader(
                      message: 'Searching the catalog...',
                    ),
                  ),
                )
              : _buildBookList(context, currentSearchList);
        }
      },
    );
  }

  Future<BookResponse> fetchData() async {
    if (!newDataRequired && currentResponse != null) return currentResponse!;
    final bookService = ref.watch(serviceProvider);
    currentResponse = bookService.queryBooks(
        searchTextController.text.trim(), currentStartPosition, pageCount);
    return currentResponse!;
  }

  Widget _buildSearchError(String message) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _errorMessage(Object? error) {
    if (error is Error) {
      return _cleanException(error.exception.toString());
    }

    if (error is Map) {
      final nestedError = error['error'];
      if (nestedError is Map) {
        final message = nestedError['message'];
        if (message is String && message.isNotEmpty) return message;
      }

      final message = error['message'];
      if (message is String && message.isNotEmpty) return message;
    }

    if (error is Exception) return _cleanException(error.toString());
    if (error != null) return error.toString();

    return 'Could not load books. Try again later.';
  }

  String _cleanException(String message) {
    return message.replaceFirst('Exception: ', '');
  }

  Widget _buildBookList(BuildContext bookListContext, List<Book> books) {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final numColumns = max(1, constraints.crossAxisExtent ~/ 264);
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: books.length,
            (BuildContext context, int index) {
              final book = books[index];
              return AnimatedSlideFade(
                delay: Duration(milliseconds: 35 * (index > 10 ? 10 : index)),
                child: AnimatedTapScale(
                  onTap: () => _openBook(bookListContext, book),
                  child: bookCardWidget(book),
                ),
              );
            },
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numColumns.toInt(), mainAxisExtent: 264),
        );
      },
    );
  }

  void _openBook(BuildContext context, Book book) {
    Navigator.push(
      context,
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookView(book: book),
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
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SegmentedButton<ListType>(
        segments: const [
          ButtonSegment(value: ListType.all, label: Text('Search')),
          ButtonSegment(value: ListType.bookmarks, label: Text('Saved Books')),
        ],
        selected: {currentType},
        onSelectionChanged: (Set<ListType> newSelection) =>
            setState(() => currentType = newSelection.first),
      ),
    );
  }
}
