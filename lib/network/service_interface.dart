import 'package:chopper/chopper.dart';
import '../data/models/recipe.dart';
import 'model_response.dart';
import 'query_result.dart';

typedef RecipeResponse = Response<Result<QueryResult>>;
typedef RecipeDetailsResponse = Response<Result<Recipe>>;

abstract class ServiceInterface {
  Future<RecipeResponse> queryRecipes(
    String query,
    int offset,
    int number,
  );

  Future<RecipeDetailsResponse> queryRecipe(
      String id,
      );
}
