import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'query_result.dart';
import 'model_response.dart';
import 'spoonacular_model.dart';

class SpoonacularConverter implements Converter {
  @override
  Request convertRequest(Request request) {
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );

    return encodeJson(req);
  }

  Request encodeJson(Request request) {
    final contentType = request.headers[contentTypeKey];
    if (contentType != null && contentType.contains(jsonHeaders)) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;
    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }
    try {
      final mapData = json.decode(body) as Map<String, dynamic>;

      if (mapData.keys.contains('totalResults')) {
        final spoonacularResults = SpoonacularResults.fromJson(mapData);
        final books = spoonacularResultsToBook(spoonacularResults);
        final apiQueryResults = QueryResult(
            offset: spoonacularResults.offset,
            number: spoonacularResults.number,
            totalResults: spoonacularResults.totalResults,
            books: books);
        return response.copyWith<BodyType>(
          body: Success(apiQueryResults) as BodyType,
        );
      } else {
        final spoonacularBook = SpoonacularRecipe.fromJson(mapData);
        final book = spoonacularRecipeToBook(spoonacularBook);
        return response.copyWith<BodyType>(
          body: Success(book) as BodyType,
        );
      }
    } catch (e) {
      final error = Error<InnerType>(Exception(e.toString()));
      return Response(response.base, null,
          error: error);
    }
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return decodeJson<BodyType, InnerType>(response);
  }
}
