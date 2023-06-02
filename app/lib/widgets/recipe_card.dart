import 'package:flutter/material.dart';
import 'package:inventory/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(recipe.name),
          Text(recipe.ingredients.toString()),
          Text(recipe.steps.toString()),
        ],
      ),
    );
  }
}
