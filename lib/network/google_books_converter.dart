import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:yummy/network/query_result.dart';
import 'package:yummy/network/model_response.dart';
import 'package:yummy/network/google_books_model.dart';

class GoogleBooksConverter implements Converter {
  @override
  Request convertRequest(Request request) {
    final requestWithHeader = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );

    if (request.body == null) return requestWithHeader;

    return requestWithHeader.copyWith(body: json.encode(request.body));
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return decodeJson<BodyType, InnerType>(response);
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;
    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }

    try {
      final mapData = json.decode(body) as Map<String, dynamic>;

      if (mapData.containsKey('error')) {
        return response.copyWith<BodyType>(
          body: Error<InnerType>(
            Exception(_googleBooksErrorMessage(mapData)),
          ) as BodyType,
        );
      }

      if (mapData.containsKey('kind') &&
          (mapData['kind'] as String).contains('volumes')) {
        final totalItems = mapData['totalItems'] as int? ?? 0;

        if (totalItems == 0 || !mapData.containsKey('items')) {
          return response.copyWith<BodyType>(
            body: Success(QueryResult(
                offset: 0,
                number: 0,
                totalResults: 0,
                books: [])) as BodyType,
          );
        }

        final googleResults = GoogleBooksResults.fromJson(mapData);
        final books = googleResults.items
                ?.map((book) => googleBookToBook(book))
                .toList() ??
            [];

        return response.copyWith<BodyType>(
          body: Success(QueryResult(
            offset: 0,
            number: books.length,
            totalResults: totalItems,
            books: books,
          )) as BodyType,
        );
      } else {
        final googleBook = GoogleBook.fromJson(mapData);
        final book = googleBookToBook(googleBook);
        return response.copyWith<BodyType>(body: Success(book) as BodyType);
      }
    } catch (e) {
      return Response(response.base, null,
          error: Error<InnerType>(Exception(e.toString())));
    }
  }

  String _googleBooksErrorMessage(Map<String, dynamic> mapData) {
    final error = mapData['error'];
    if (error is Map<String, dynamic>) {
      final message = error['message'];
      if (message is String && message.isNotEmpty) return message;
    }

    return 'Google Books API returned an error.';
  }
}
