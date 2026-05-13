import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../data/models/book.dart';
import '../../providers.dart';
import '../recipes/book_view.dart';

class Bookmarks extends ConsumerStatefulWidget {
  const Bookmarks({super.key});

  @override
  ConsumerState createState() => _BookmarkState();
}

class _BookmarkState extends ConsumerState<Bookmarks> {
  List<Book> books = [];
  late Stream<List<Book>> bookStream;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(repositoryProvider.notifier);
    bookStream = repository.watchAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBookmarks(context);
  }

  Widget _buildBookmarks(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: bookStream,
      builder: (context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          books = snapshot.data ?? [];
        }
        return SliverLayoutBuilder(
          builder: (BuildContext context, SliverConstraints constraints) {
            return SliverList.builder(
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                final book = books[index];
                return SizedBox(
                  height: 100,
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          icon: Icons.delete,
                          onPressed: (context) {
    	                    deleteBook(book);
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          icon: Icons.delete,
                          onPressed: (context) {
                   	     deleteBook(book);
                          },
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BookView(
                                book: book.copyWith(bookmarked: true));
                          },
                        ));
                      },
                      child: Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: book.image ?? '',
                                height: 120,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                              title: Text(book.label ?? ''),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void deleteBook(Book book) {
    ref.read(repositoryProvider.notifier).deleteBook(book);
  }
}
