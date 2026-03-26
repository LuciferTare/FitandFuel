import 'package:fit_and_fuel/features/recipe/controller/controller.dart';
import 'package:fit_and_fuel/features/widgets/nav_button.dart';
import 'package:fit_and_fuel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Recipe extends StatefulWidget {
  final int id;

  const Recipe({super.key, required this.id});

  @override
  State<Recipe> createState() => RecipeState();
}

class RecipeState extends State<Recipe> {
  final recipeController = Get.find<RecipeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRecipe();
    });
  }

  Future<void> loadRecipe() async {
    await recipeController.getRecipe(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 1});
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF181A20),
        body: Obx(() {
          if (recipeController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFCD535)),
            );
          }

          final recipe = recipeController.recipe.value;
          final ingredients = recipe.ingredients;
          final steps = recipe.steps;
          final tips = recipe.tips;

          return RefreshIndicator(
            color: const Color(0xFFFCD535),
            onRefresh: loadRecipe,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 600,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                recipe.image ??
                                    'assets/recipe-thumb/default.png',
                                width: screenWidth,
                                height: screenWidth,
                                colorBlendMode: BlendMode.lighten,
                                color: Color(0xFF181A20),
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x00181A20),
                                        Color(0x3E181A20),
                                        Color(0xFF181A20),
                                      ],
                                      stops: [0, 0.6, 0.95],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 15,
                            left: 15,
                            child: GestureDetector(
                              onTap:
                                  () => Get.offAllNamed(
                                    MyRoutes.shellRoute,
                                    arguments: {'idx': 1},
                                  ),
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0x7ED9D9D9),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 15,
                                  color: Color(0xFFD9D9D9),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 350,
                            left: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0x13D9D9D9),
                                border: Border.all(color: Color(0x3ED9D9D9)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${recipe.heading}',
                                          style: TextStyle(
                                            height: 1,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFFD9D9D9),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0x3EFCD535),
                                          border: Border.all(
                                            color: Color(0x7EFCD535),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 7.5,
                                          horizontal: 10,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Serves ${recipe.serve}',
                                            style: TextStyle(
                                              height: 1,
                                              fontSize: 16,
                                              color: Color(0xFFFCD535),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF181A20),
                                      border: Border.all(
                                        color: Color(0x3ED9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: macrosText(
                                            'CAL',
                                            '${recipe.cal}',
                                            Color(0xFFFCD535),
                                            true,
                                          ),
                                        ),
                                        Expanded(
                                          child: macrosText(
                                            'PROTEIN',
                                            '${recipe.protien}g',
                                            Color(0xFFD9D9D9),
                                            true,
                                          ),
                                        ),
                                        Expanded(
                                          child: macrosText(
                                            'CARBS',
                                            '${recipe.carbs}g',
                                            Color(0xFFD9D9D9),
                                            true,
                                          ),
                                        ),
                                        Expanded(
                                          child: macrosText(
                                            'FAT',
                                            '${recipe.fat}g',
                                            Color(0xFFD9D9D9),
                                            false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ingredients != null && ingredients.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Row(
                          children: [
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xBED9D9D9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 7.5,
                          runSpacing: 7.5,
                          children:
                              ingredients.map((i) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7.5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x13D9D9D9),
                                    border: Border.all(
                                      width: 0.5,
                                      color: const Color(0x3ED9D9D9),
                                    ),
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                  child: Text(
                                    i,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFD9D9D9),
                                      height: 1,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                    if (steps != null && steps.isNotEmpty) ...[
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              'Steps',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xBED9D9D9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemCount: steps.length,
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          final isLast = index == steps.length - 1;

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 7.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0x13FCD535),
                                        border: Border.all(
                                          color: Color(0xFFFCD535),
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            height: 1,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFFFCD535),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (!isLast)
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: Color(0x3ED9D9D9),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 7.5),
                                    child: Text(
                                      step,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xBED9D9D9),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    if (tips != null && tips.isNotEmpty) ...[
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              'Pro Tips',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xBED9D9D9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tips.length,
                        itemBuilder: (context, index) {
                          final tip = tips[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: Color(0x13FCD535),
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFFFCD535),
                                  width: 3,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.symmetric(vertical: 7.5),
                                  decoration: BoxDecoration(
                                    color: Color(0x13FCD535),
                                    border: Border.all(
                                      color: Color(0xFFFCD535),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.lightbulb,
                                      size: 20,
                                      color: Color(0xFFFCD535),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFD9D9D9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x0BD9D9D9),
              border: Border.all(width: 1, color: const Color(0x18D9D9D9)),
              borderRadius: BorderRadius.circular(38),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navButton(
                  image: 'assets/images/home.png',
                  isActive: false,
                  label: 'Home',
                  onTap: () {
                    Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 0});
                  },
                ),
                navButton(
                  image: 'assets/images/recipe.png',
                  isActive: true,
                  label: 'Recipe',
                  onTap: () {
                    Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 1});
                  },
                ),
                navButton(
                  image: 'assets/images/music.png',
                  isActive: false,
                  label: 'Music',
                  onTap: () {
                    Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 2});
                  },
                ),
                navButton(
                  image: 'assets/images/calculator.png',
                  isActive: false,
                  label: 'Calc.',
                  onTap: () {
                    Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 3});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget macrosText(String text, String value, Color color, bool showDivider) {
    return Container(
      decoration: BoxDecoration(
        border:
            showDivider
                ? Border(
                  right: BorderSide(width: 0.5, color: Color(0x3ED9D9D9)),
                )
                : null,
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              height: 1,
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0x3ED9D9D9),
            ),
          ),
        ],
      ),
    );
  }
}
