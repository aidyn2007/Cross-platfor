import 'package:chopper/chopper.dart';
import '../data/models/book.dart';
import 'model_response.dart';
import 'query_result.dart';
import 'service_interface.dart';
import 'spoonacular_model.dart';
import 'spoonacular_converter.dart';

part 'spoonacular_service.chopper.dart';

// Замените этот ключ на ваш реальный ключ с сайта spoonacular.com
const String apiKey = '83074092b70f443b81128383a8b23f2b';
const String apiUrl = 'https://api.spoonacular.com/';

@ChopperApi()
abstract class SpoonacularService extends ChopperService
    implements ServiceInterface {
  @override
  @Get(path: 'recipes/{id}/information?includeNutrition=false')
  Future<BookDetailsResponse> queryBook(
    @Path('id') String id,
  );

  @override
  @Get(path: 'recipes/complexSearch')
  Future<BookResponse> queryBooks(
    @Query('query') String query,
    @Query('offset') int offset,
    @Query('number') int number,
  );

  static SpoonacularService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(apiUrl),
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      converter: SpoonacularConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$SpoonacularService(),
      ],
    );
    return _$SpoonacularService(client);
  }
}

Request _addQuery(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);
  params['apiKey'] = apiKey;

  return req.copyWith(parameters: params);
}
