import 'dart:async';

import 'package:chopper/chopper.dart';
import '../data/models/recipe.dart';
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
  Future<RecipeDetailsResponse> queryRecipe(
    @Path('id') String id,
  );

  @override
  @Get(path: 'recipes/complexSearch')
  Future<RecipeResponse> queryRecipes(
    @Query('query') String query,
    @Query('offset') int offset,
    @Query('number') int number,
  );

  static SpoonacularService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(apiUrl),
      interceptors: [_AddQueryInterceptor(), HttpLoggingInterceptor()],
      converter: SpoonacularConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$SpoonacularService(),
      ],
    );
    return _$SpoonacularService(client);
  }
}

class _AddQueryInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final request = chain.request;
    final params = Map<String, dynamic>.from(request.parameters);
    params['apiKey'] = apiKey;
    final updatedRequest = request.copyWith(parameters: params);
    return chain.proceed(updatedRequest);
  }
}
