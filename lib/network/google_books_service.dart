import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:yummy/data/models/book.dart';
import 'package:yummy/network/model_response.dart';
import 'package:yummy/network/query_result.dart';
import 'package:yummy/network/service_interface.dart';
import 'package:yummy/network/google_books_converter.dart';

part 'google_books_service.chopper.dart';

const String googleBooksUrl = 'https://www.googleapis.com/books/v1/';
const String googleBooksApiKey = String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

class _AddGoogleBooksApiKeyInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final request = chain.request;
    if (googleBooksApiKey.isEmpty) return chain.proceed(request);

    final updatedRequest = request.copyWith(
      parameters: {
        ...request.parameters,
        'key': googleBooksApiKey,
      },
    );
    return chain.proceed(updatedRequest);
  }
}

@ChopperApi()
abstract class GoogleBooksService extends ChopperService
    implements ServiceInterface {
  @override
  @Get(path: 'volumes/{id}')
  Future<BookDetailsResponse> queryBook(
    @Path('id') String id,
  );

  @override
  @Get(path: 'volumes')
  Future<BookResponse> queryBooks(
    @Query('q') String query,
    @Query('startIndex') int offset,
    @Query('maxResults') int number,
  );

  static GoogleBooksService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(googleBooksUrl),
      interceptors: [
        HttpLoggingInterceptor(),
        _AddGoogleBooksApiKeyInterceptor(),
      ],
      converter: GoogleBooksConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$GoogleBooksService(),
      ],
    );
    return _$GoogleBooksService(client);
  }
}
