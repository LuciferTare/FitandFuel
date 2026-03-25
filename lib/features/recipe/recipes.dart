import 'package:fit_and_fuel/features/recipe/controller/controller.dart';
import 'package:fit_and_fuel/features/recipe/model/model.dart' as model;
import 'package:fit_and_fuel/features/widgets/custom_card.dart';
import 'package:fit_and_fuel/features/widgets/custom_textfields.dart';
import 'package:fit_and_fuel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => RecipeListState();
}

class RecipeListState extends State<RecipeList> {
  final recipeController = Get.find<RecipeController>();
  List<model.RecipeListModel> recipes = [];
  final searchC = TextEditingController();
  final searchFN = FocusNode();

  @override
  void initState() {
    super.initState();
    searchC.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchC.removeListener(onSearchChanged);
    searchC.dispose();
    searchFN.dispose();
    super.dispose();
  }

  void onSearchChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 0});
      },
      child: Scaffold(
        backgroundColor: Color(0xFF181A20),
        body: Obx(() {
          if (recipeController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFFCD535)),
            );
          }

          recipes = recipeController.recipeList;
          final query = searchC.text.trim().toLowerCase();
          final displayRecipes =
              query.isEmpty
                  ? recipes
                  : recipes
                      .where(
                        (r) =>
                            r.heading?.toLowerCase().contains(query) ?? false,
                      )
                      .toList();
          final titleText =
              displayRecipes.isEmpty && query.isNotEmpty
                  ? 'No Featured Recipe'
                  : 'Featured Recipes';

          return RefreshIndicator(
            color: Color(0xFFFCD535),
            onRefresh: () async {
              await recipeController.getRecipes();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      searchTextField(
                        context: context,
                        keyboardType: TextInputType.text,
                        controller: searchC,
                        labeltext: 'Search',
                        enabled: true,
                        obscureText: false,
                        focusNode: searchFN,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        titleText,
                        style: TextStyle(
                          height: 1,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: displayRecipes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final recipe = displayRecipes[index];
                      return recipeCard(recipe: recipe);
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
