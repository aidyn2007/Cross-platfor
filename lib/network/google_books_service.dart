import 'dart:async';
import 'package:chopper/chopper.dart';

import '../data/models/book.dart';
import 'google_books_converter.dart';
import 'model_response.dart';
import 'query_result.dart';
import 'service_interface.dart';

part 'google_books_service.chopper.dart';

const String googleBooksUrl = 'https://www.googleapis.com/books/v1/';
const String googleBooksApiKey = String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

class _AddGoogleBooksApiKeyInterceptor implements Interceptor {
  const _AddGoogleBooksApiKeyInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) {
    if (googleBooksApiKey.isEmpty) return chain.proceed(chain.request);

    final request = chain.request.copyWith(
      parameters: {
        ...chain.request.parameters,
        'key': googleBooksApiKey,
      },
    );

    return chain.proceed(request);
  }
}

@ChopperApi()
abstract class GoogleBooksService extends ChopperService
    implements ServiceInterface {
  @override
  @GET(path: 'volumes/{id}')
  Future<BookDetailsResponse> queryBook(
    @Path('id') String id,
  );

  @override
  @GET(path: 'volumes')
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
        const _AddGoogleBooksApiKeyInterceptor(),
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
