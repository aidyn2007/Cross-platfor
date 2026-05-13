import 'package:chopper/chopper.dart';
import '../data/models/book.dart';
import 'model_response.dart';
import 'query_result.dart';

typedef BookResponse = Response<Result<QueryResult>>;
typedef BookDetailsResponse = Response<Result<Book>>;

abstract class ServiceInterface {
  Future<BookResponse> queryBooks(
    String query,
    int offset,
    int number,
  );

  Future<BookDetailsResponse> queryBook(
      String id,
      );
}
