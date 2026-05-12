import 'models.dart';

class CurrentRecipeData {
  final List<Recipe> currentRecipes;
  final List<Ingredient> currentIngredients;

  const CurrentRecipeData({
    this.currentRecipes = const <Recipe>[],
    this.currentIngredients = const <Ingredient>[],
  });

  CurrentRecipeData copyWith({
    List<Recipe>? currentRecipes,
    List<Ingredient>? currentIngredients,
  }) {
    return CurrentRecipeData(
      currentRecipes: currentRecipes ?? this.currentRecipes,
      currentIngredients: currentIngredients ?? this.currentIngredients,
    );
  }
}
