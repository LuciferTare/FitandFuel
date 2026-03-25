import 'package:fit_and_fuel/features/recipe/model/model.dart' as model;
import 'package:fit_and_fuel/features/recipe/recipe.dart';
import 'package:fit_and_fuel/features/widgets/converters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget recipeCard({required model.RecipeListModel recipe}) {
  final cal = formatNumber(recipe.cal);
  final carbs = formatNumber(recipe.carbs);
  final fat = formatNumber(recipe.fat);
  final protien = formatNumber(recipe.protien);

  return GestureDetector(
    onTap: () => Get.to(() => Recipe(id: recipe.id ?? 0)),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x0BD9D9D9),
        border: Border.all(width: 0.5, color: Color(0x3ED9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints.tightFor(width: 75, height: 75),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                recipe.image ?? 'assets/recipe-thumb/default.png',
                colorBlendMode: BlendMode.lighten,
                color: Color(0xFF181A20),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${recipe.heading}',
                          style: TextStyle(
                            height: 1.1,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.5,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0x3ED9D9D9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${recipe.serve} Serves',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cal',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0x7ED9D9D9),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '$cal',
                            style: TextStyle(
                              height: 1,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFCD535),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'P',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0x7ED9D9D9),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${protien}g',
                            style: TextStyle(
                              height: 1,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'C',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0x7ED9D9D9),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${carbs}g',
                            style: TextStyle(
                              height: 1,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'F',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0x7ED9D9D9),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${fat}g',
                            style: TextStyle(
                              height: 1,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
