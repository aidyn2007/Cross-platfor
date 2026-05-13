import 'models.dart';

class CurrentBookData {
  final List<Book> currentBooks;
  final List<BookTag> currentTags;

  const CurrentBookData({
    this.currentBooks = const <Book>[],
    this.currentTags = const <BookTag>[],
  });

  CurrentBookData copyWith({
    List<Book>? currentBooks,
    List<BookTag>? currentTags,
  }) {
    return CurrentBookData(
      currentBooks: currentBooks ?? this.currentBooks,
      currentTags: currentTags ?? this.currentTags,
    );
  }
}
