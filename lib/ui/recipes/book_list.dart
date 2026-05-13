import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yummy/network/service_interface.dart';
import 'package:yummy/data/models/models.dart';
import 'package:yummy/network/model_response.dart';
import 'package:yummy/network/query_result.dart';
import 'package:yummy/providers.dart';
import 'package:yummy/ui/bookmarks/bookmarks.dart';
import 'package:yummy/ui/book_card.dart';
import 'package:yummy/ui/recipes/book_view.dart';

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
  ListType currentType = ListType.all;
  Future<BookResponse>? currentResponse;
  bool newDataRequired = true;

  @override
  void initState() {
    super.initState();
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

  void startSearch(String value) {
    setState(() {
      currentSearchList.clear();
      newDataRequired = true;
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = false;
      currentResponse = null;
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => startSearch(searchTextController.text),
            ),
            Expanded(
              child: TextField(
                controller: searchTextController,
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
          ],
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
                  child: Center(child: CircularProgressIndicator()))
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

  Widget _buildBookList(
      BuildContext bookListContext, List<Book> books) {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        final numColumns = max(1, constraints.crossAxisExtent ~/ 264);
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: books.length,
            (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    bookListContext,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookView(book: books[index]),
                    )),
                child: bookCardWidget(books[index]),
              );
            },
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numColumns.toInt(), mainAxisExtent: 264),
        );
      },
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
