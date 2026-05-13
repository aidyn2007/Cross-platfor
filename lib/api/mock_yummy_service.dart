import '../models/models.dart';

// ExploreData serves as a data container that holds
//list of bookstores, food categories, and friend posts.
class ExploreData {
  final List<Bookstore> bookstores;
  final List<BookCategory> categories;
  final List<Post> friendPosts;

  ExploreData(this.bookstores, this.categories, this.friendPosts);
}

// Mock Yummy service that grabs sample data to mock up a food app request/response
class MockYummyService {
  // Batch request that gets both today books and friend's feed
  Future<ExploreData> getExploreData() async {
    final bookstores = await _getBookstores();
    final categories = await _getCategories();
    final friendPosts = await _getFriendFeed();

    return ExploreData(bookstores, categories, friendPosts);
  }

  // Get sample food categories to display in ui
  Future<List<BookCategory>> _getCategories() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock categories
    return categories;
  }

  // Get the friend posts to display in ui
  Future<List<Post>> _getFriendFeed() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock posts
    return posts;
  }

  // Get the bookstores to display in ui
  Future<List<Bookstore>> _getBookstores() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock bookstores
    return bookstores;
  }
}
