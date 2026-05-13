import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../data/models/book.dart';
import '../network/model_response.dart';
import '../network/query_result.dart';
import '../network/service_interface.dart';
import '../network/spoonacular_model.dart';
import 'package:http/http.dart' as http;
import 'package:chopper/chopper.dart';

class MockService implements ServiceInterface {
  late QueryResult _currentBooks1;
  late QueryResult _currentBooks2;
  late Book bookDetails;
  Random nextBook = Random();

  static Future<MockService> create() async {
    final mockService = MockService();
    await mockService.loadBooks();
    return mockService;
  }

  Future loadBooks() async {
    // Book List 1
    var jsonString = await rootBundle.loadString('assets/recipes1.json');
    var spoonacularResults =
        SpoonacularResults.fromJson(jsonDecode(jsonString));
    var books = spoonacularResultsToBook(spoonacularResults);
    var apiQueryResults = QueryResult(
        offset: spoonacularResults.offset,
        number: spoonacularResults.number,
        totalResults: spoonacularResults.totalResults,
        books: books);
    _currentBooks1 = apiQueryResults;

    // Book List 2
    jsonString = await rootBundle.loadString('assets/recipes2.json');
    spoonacularResults = SpoonacularResults.fromJson(jsonDecode(jsonString));
    books = spoonacularResultsToBook(spoonacularResults);
    apiQueryResults = QueryResult(
        offset: spoonacularResults.offset,
        number: spoonacularResults.number,
        totalResults: spoonacularResults.totalResults,
        books: books);
    _currentBooks2 = apiQueryResults;

    // Book Details
    jsonString = await rootBundle.loadString('assets/recipe_details.json');
    final spoonacularRecipe =
        SpoonacularRecipe.fromJson(jsonDecode(jsonString));
    spoonacularRecipe.id = books[0].id!;
    bookDetails = spoonacularRecipeToBook(spoonacularRecipe);
  }

  @override
  Future<BookResponse> queryBooks(
    String query,
    int offset,
    int number,
  ) {
    switch (nextBook.nextInt(2)) {
      case 0:
        return Future.value(
          Response(
            http.Response(
              'Dummy',
              200,
              request: null,
            ),
            Success<QueryResult>(_currentBooks1),
          ),
        );
      case 1:
        return Future.value(
          Response(
            http.Response(
              'Dummy',
              200,
              request: null,
            ),
            Success<QueryResult>(_currentBooks2),
          ),
        );
      default:
        return Future.value(
          Response(
            http.Response(
              'Dummy',
              200,
              request: null,
            ),
            Success<QueryResult>(_currentBooks1),
          ),
        );
    }
  }

  @override
  Future<BookDetailsResponse> queryBook(String id) {
    return Future.value(
      Response(
        http.Response(
          'Dummy',
          200,
          request: null,
        ),
        Success<Book>(bookDetails),
      ),
    );
  }
}
