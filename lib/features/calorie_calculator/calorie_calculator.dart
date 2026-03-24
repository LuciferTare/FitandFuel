import 'package:fit_and_fuel/features/recipe/controller/controller.dart';
import 'package:fit_and_fuel/features/recipe/model/model.dart' as model;
import 'package:fit_and_fuel/features/widgets/custom_buttons.dart';
import 'package:fit_and_fuel/features/widgets/custom_card.dart';
import 'package:fit_and_fuel/features/widgets/custom_textfields.dart';
import 'package:fit_and_fuel/features/widgets/snackbar.dart';
import 'package:fit_and_fuel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalorieCalculator extends StatefulWidget {
  const CalorieCalculator({super.key});

  @override
  State<CalorieCalculator> createState() => CalorieCalculatorState();
}

class CalorieCalculatorState extends State<CalorieCalculator> {
  final recipeController = Get.find<RecipeController>();
  List<model.RecipeListModel> suggestedRecipes = [];
  String selectedGoal = 'Gain', selectedGender = 'Male';
  bool allField = false, calculatedMacros = false, showSuggestions = false;
  final ageC = TextEditingController();
  final heightC = TextEditingController();
  final weightC = TextEditingController();
  final mealsC = TextEditingController();
  final ageFN = FocusNode();
  final heightFN = FocusNode();
  final weightFN = FocusNode();
  final mealsFN = FocusNode();
  double? calories, protein, fat, carbs;

  @override
  void initState() {
    super.initState();
    addFocusListeners([ageFN, heightFN, weightFN, mealsFN]);

    ageFN.addListener(checkAllFields);
    heightFN.addListener(checkAllFields);
    weightFN.addListener(checkAllFields);
    mealsFN.addListener(checkAllFields);
  }

  @override
  void dispose() {
    ageC.dispose();
    heightC.dispose();
    weightC.dispose();
    mealsC.dispose();
    ageFN.dispose();
    heightFN.dispose();
    weightFN.dispose();
    mealsFN.dispose();
    super.dispose();
  }

  void addFocusListeners(List<FocusNode> nodes) {
    for (var node in nodes) {
      node.addListener(() => setState(() {}));
    }
  }

  void checkAllFields() {
    final allFilled =
        ageC.text.isNotEmpty &&
        heightC.text.isNotEmpty &&
        weightC.text.isNotEmpty;

    if (allField != allFilled) {
      setState(() {
        allField = allFilled;
      });
    }
  }

  Map<String, double> calculateMacros({
    required String goal,
    required String gender,
    required int age,
    required double height,
    required double weight,
  }) {
    double bmr =
        (gender == 'Male')
            ? 10 * weight + 6.25 * height - 5 * age + 5
            : 10 * weight + 6.25 * height - 5 * age - 161;
    double activityFactor = 1.2;
    double tdee = bmr * activityFactor;
    double calories;
    switch (goal) {
      case 'Gain':
        calories = tdee * 1.15;
        break;
      case 'Lose':
        calories = tdee * 0.85;
        break;
      default:
        calories = tdee;
    }

    double proteinGrams = 1.8 * weight;
    double fatGrams = 0.8 * weight;
    double proteinCals = proteinGrams * 4;
    double fatCals = fatGrams * 9;
    double carbCals = calories - (proteinCals + fatCals);
    double carbGrams = carbCals > 0 ? carbCals / 4 : 0;

    return {
      'calories': calories,
      'protein_g': proteinGrams,
      'fat_g': fatGrams,
      'carbs_g': carbGrams,
    };
  }

  void suggestRecipes() {
    if (!calculatedMacros ||
        calories == null ||
        protein == null ||
        fat == null ||
        carbs == null) {
      errorSnackbar(msg: 'Please calculate macros first');
      return;
    }

    final meals = (int.tryParse(mealsC.text.trim()) ?? 1).clamp(1, 99);
    final targetCal = calories!;
    final targetProtein = protein!;
    final targetFat = fat!;
    final targetCarbs = carbs!;
    final usePerMeal = meals > 1;
    final targetCalForMatching = usePerMeal ? (targetCal / meals) : targetCal;
    final targetProteinForMatching =
        usePerMeal ? (targetProtein / meals) : targetProtein;
    final targetFatForMatching = usePerMeal ? (targetFat / meals) : targetFat;
    final targetCarbsForMatching =
        usePerMeal ? (targetCarbs / meals) : targetCarbs;
    final allRecipes = recipeController.recipeList;
    final scored = <MapEntry<model.RecipeListModel, double>>[];
    for (final r in allRecipes) {
      final serve = (r.serve ?? 1).toDouble();
      final calTotal = (r.cal ?? 0) * serve;
      final proteinTotal = (r.protien ?? 0) * serve;
      final fatTotal = (r.fat ?? 0) * serve;
      final carbsTotal = (r.carbs ?? 0) * serve;
      final calErr =
          targetCalForMatching > 0
              ? ((calTotal - targetCalForMatching).abs() / targetCalForMatching)
              : ((calTotal - targetCalForMatching).abs() /
                  (1 + targetCalForMatching));
      final proteinErr =
          targetProteinForMatching > 0
              ? ((proteinTotal - targetProteinForMatching).abs() /
                  targetProteinForMatching)
              : ((proteinTotal - targetProteinForMatching).abs() /
                  (1 + targetProteinForMatching));
      final fatErr =
          targetFatForMatching > 0
              ? ((fatTotal - targetFatForMatching).abs() / targetFatForMatching)
              : ((fatTotal - targetFatForMatching).abs() /
                  (1 + targetFatForMatching));
      final carbsErr =
          targetCarbsForMatching > 0
              ? ((carbsTotal - targetCarbsForMatching).abs() /
                  targetCarbsForMatching)
              : ((carbsTotal - targetCarbsForMatching).abs() /
                  (1 + targetCarbsForMatching));
      final score =
          calErr * 0.5 + proteinErr * 0.2 + fatErr * 0.15 + carbsErr * 0.15;
      final threshold = usePerMeal ? 0.30 : 0.35;

      if (score <= threshold) {
        scored.add(MapEntry(r, score));
      }
    }

    scored.sort((a, b) => a.value.compareTo(b.value));

    setState(() {
      suggestedRecipes = scored.map((e) => e.key).toList();
      showSuggestions = true;
    });

    if (suggestedRecipes.isEmpty) {
      errorSnackbar(
        msg:
            'No recipes match your macro goal closely. Try adjusting number of meals or goal.',
      );
    }
  }

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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Calorie Calculator',
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
              Container(
                decoration: BoxDecoration(
                  color: Color(0x13D9D9D9),
                  border: Border.all(width: 0.5, color: Color(0x3ED9D9D9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Set you Goal',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xBED9D9D9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF181A20),
                      ),
                      child: Row(
                        children: [
                          goalButton('Gain'),
                          goalButton('Lose'),
                          goalButton('Maintain'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xBED9D9D9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        genderButton('Male'),
                        SizedBox(width: 10),
                        genderButton('Female'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        buildTextField(
                          keyboardType: TextInputType.number,
                          controller: ageC,
                          labeltext: 'Age',
                          enabled: true,
                          obscureText: false,
                          focusNode: ageFN,
                          context: context,
                        ),
                        SizedBox(width: 10),
                        buildTextField(
                          keyboardType: TextInputType.number,
                          controller: heightC,
                          labeltext: 'Height (cm)',
                          enabled: true,
                          obscureText: false,
                          focusNode: heightFN,
                          context: context,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        buildTextField(
                          keyboardType: TextInputType.number,
                          controller: weightC,
                          labeltext: 'Weight (kg)',
                          enabled: true,
                          obscureText: false,
                          focusNode: weightFN,
                          context: context,
                        ),
                        SizedBox(width: 10),
                        buildTextField(
                          keyboardType: TextInputType.number,
                          controller: mealsC,
                          labeltext: 'No. of Meals',
                          enabled: true,
                          obscureText: false,
                          focusNode: mealsFN,
                          context: context,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        buildButtons(
                          flex: 3,
                          color:
                              allField ? Color(0xFFFCD535) : Color(0xBED9D9D9),
                          label: 'Calculate',
                          labelColor: Color(0xFF181A20),
                          onPressed: () {
                            if (ageC.text.isEmpty ||
                                heightC.text.isEmpty ||
                                weightC.text.isEmpty) {
                              errorSnackbar(msg: 'Please fill out all fields');
                            } else {
                              final age = int.tryParse(ageC.text);
                              final height = double.tryParse(heightC.text);
                              final weight = double.tryParse(weightC.text);
                              if (age == null ||
                                  height == null ||
                                  weight == null) {
                                errorSnackbar(
                                  msg: 'Please enter valid numeric values',
                                );
                                return;
                              }
                              final results = calculateMacros(
                                goal: selectedGoal,
                                gender: selectedGender,
                                age: age,
                                height: height,
                                weight: weight,
                              );
                              setState(() {
                                calories = double.parse(
                                  results['calories']!.toStringAsFixed(2),
                                );
                                protein = double.parse(
                                  results['protein_g']!.toStringAsFixed(2),
                                );
                                fat = double.parse(
                                  results['fat_g']!.toStringAsFixed(2),
                                );
                                carbs = double.parse(
                                  results['carbs_g']!.toStringAsFixed(2),
                                );
                                calculatedMacros = true;
                              });
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        buildButtons(
                          flex: 2,
                          color: Color(0x18D9D9D9),
                          label: 'Reset',
                          labelColor: Color(0xFFD9D9D9),
                          onPressed: () {
                            setState(() {
                              selectedGoal = 'Gain';
                              selectedGender = 'Male';
                              ageC.clear();
                              heightC.clear();
                              weightC.clear();
                              mealsC.clear();
                              calories = null;
                              protein = null;
                              fat = null;
                              carbs = null;
                              calculatedMacros = false;
                              allField = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (calculatedMacros) ...[
                SizedBox(height: 10),
                Row(
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Your Calorie Goal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..color = Color(0xBED9D9D9),
                          ),
                        ),
                        Text(
                          'Your Calorie Goal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xBED9D9D9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0x00FCD535),
                        Color(0x0BFCD535),
                        Color(0x13FCD535),
                      ],
                      stops: [0.25, 0.9, 1],
                    ),
                    border: Border.all(width: 0.5, color: Color(0x3ED9D9D9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0x3ED9D9D9)),
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Stack(
                              children: [
                                Text(
                                  '$calories',
                                  style: TextStyle(
                                    height: 1,
                                    foreground:
                                        Paint()
                                          ..style = PaintingStyle.stroke
                                          ..color = Color(0xFFFCD535),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '$calories',
                                  style: TextStyle(
                                    height: 1,
                                    color: Color(0xFFFCD535),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 7.5),
                            Text(
                              'kcal / day',
                              style: TextStyle(
                                height: 1,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0x7ED9D9D9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            macrosText(
                              'Protein',
                              '${protein}g',
                              Color(0xFFD9D9D9),
                            ),
                            macrosText('Fat', '${fat}g', Color(0xFFD9D9D9)),
                            macrosText('Carbs', '${carbs}g', Color(0xFFD9D9D9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if ((int.tryParse(mealsC.text.trim()) ?? 1) > 1) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Text(
                            'Per-meal breakdown (${mealsC.text} Meals)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              foreground:
                                  Paint()
                                    ..style = PaintingStyle.stroke
                                    ..color = Color(0x7ED9D9D9),
                            ),
                          ),
                          Text(
                            'Per-meal breakdown (${mealsC.text} Meals)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0x7ED9D9D9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10,
                      children: [
                        perMealCard(
                          'CALORIES',
                          '${(calories! / (int.tryParse(mealsC.text.trim()) ?? 1)).toStringAsFixed(2)}',
                          Color(0xFFFCD535),
                        ),
                        perMealCard(
                          'PROTEIN',
                          '${(protein! / (int.tryParse(mealsC.text.trim()) ?? 1)).toStringAsFixed(2)}g',
                          Color(0xFFD9D9D9),
                        ),
                        perMealCard(
                          'FATS',
                          '${(fat! / (int.tryParse(mealsC.text.trim()) ?? 1)).toStringAsFixed(2)}g',
                          Color(0xFFD9D9D9),
                        ),
                        perMealCard(
                          'CARBS',
                          '${(carbs! / (int.tryParse(mealsC.text.trim()) ?? 1)).toStringAsFixed(2)}g',
                          Color(0xFFD9D9D9),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 10),
                Row(
                  children: [
                    buildButtons(
                      color: Color(0xFFFCD535),
                      label: 'Suggest Recipes For Macros',
                      labelColor: Color(0xFF181A20),
                      onPressed: suggestRecipes,
                    ),
                  ],
                ),
              ],
              if (showSuggestions) ...[
                SizedBox(height: 10),
                Row(
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Suggested Recipes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..color = Color(0x7ED9D9D9),
                          ),
                        ),
                        Text(
                          'Suggested Recipes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0x7ED9D9D9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                if (suggestedRecipes.isEmpty)
                  Text(
                    'No suggested recipes found.',
                    style: TextStyle(color: Color(0xFF888888)),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: suggestedRecipes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final recipe = suggestedRecipes[index];
                      return recipeCard(recipe: recipe);
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget goalButton(String label) {
    final isSelected = selectedGoal == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGoal = label),
        child: Container(
          constraints: BoxConstraints.tightFor(height: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Color(0xFFFCD535) : Color(0x00D9D9D9),
          ),
          padding: EdgeInsets.all(5),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Color(0xFF181A20) : Color(0xFFD9D9D9),
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget genderButton(String label) {
    final isSelected = selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = label),
        child: Container(
          constraints: BoxConstraints.tightFor(height: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Color(0xFFFCD535) : Color(0x18D9D9D9),
          ),
          padding: EdgeInsets.all(5),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Color(0xFF181A20) : Color(0xBED9D9D9),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget macrosText(String text, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            height: 1,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xBED9D9D9),
          ),
        ),
        SizedBox(height: 10),
        Stack(
          children: [
            Text(
              value,
              style: TextStyle(
                height: 1,
                fontSize: 20,
                foreground:
                    Paint()
                      ..style = PaintingStyle.stroke
                      ..color = color,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                height: 1,
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget perMealCard(String text, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x13D9D9D9),
        border: Border.all(width: 0.5, color: Color(0x3ED9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              height: 1,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xBED9D9D9),
            ),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Text(
                value,
                style: TextStyle(
                  height: 1,
                  fontSize: 20,
                  foreground:
                      Paint()
                        ..style = PaintingStyle.stroke
                        ..color = color,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  height: 1,
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
