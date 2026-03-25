import 'package:fit_and_fuel/features/calorie_calculator/calorie_calculator.dart';
import 'package:fit_and_fuel/features/home/controller/controller.dart';
import 'package:fit_and_fuel/features/home/home.dart';
import 'package:fit_and_fuel/features/music/controller/controller.dart';
import 'package:fit_and_fuel/features/music/music.dart';
import 'package:fit_and_fuel/features/recipe/controller/controller.dart';
import 'package:fit_and_fuel/features/recipe/recipes.dart';
import 'package:fit_and_fuel/features/widgets/app_bar.dart';
import 'package:fit_and_fuel/features/widgets/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainShell extends StatefulWidget {
  final int initialIdx;

  MainShell({super.key, this.initialIdx = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIdx = 0;
  final List<Widget?> cachedPages = List<Widget?>.filled(5, null);

  @override
  void initState() {
    super.initState();
    currentIdx =
        widget.initialIdx >= 0 && widget.initialIdx < cachedPages.length
            ? widget.initialIdx
            : 0;
    ensureBinding(currentIdx);
    cachedPages[currentIdx] = createPageForIdx(currentIdx);
  }

  Widget createPageForIdx(int idx) {
    switch (idx) {
      case 0:
        return Home();
      case 1:
        return RecipeList();
      case 2:
        return Music();
      case 3:
        return CalorieCalculator();
      default:
        return Home();
    }
  }

  Widget getPage(int idx) {
    ensureBinding(idx);

    if (cachedPages[idx] == null) {
      cachedPages[idx] = createPageForIdx(idx);
    }
    return cachedPages[idx]!;
  }

  void ensureBinding(int idx) {
    switch (idx) {
      case 0:
        if (!Get.isRegistered<HomeController>()) {
          Get.lazyPut(() => HomeController());
        }
        break;
      case 1:
        if (!Get.isRegistered<RecipeController>()) {
          Get.lazyPut(() => RecipeController());
        }
        break;
      case 2:
        if (!Get.isRegistered<MusicController>()) {
          Get.put(MusicController(), permanent: true);
        }
        break;
      case 3:
        if (!Get.isRegistered<RecipeController>()) {
          Get.lazyPut(() => RecipeController());
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181A20),
      appBar: appBar(context: context),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(currentIdx),
          child: getPage(currentIdx),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0x0BD9D9D9),
          border: Border.all(width: 1, color: Color(0x18D9D9D9)),
          borderRadius: BorderRadius.circular(38),
        ),
        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navButton(
              image: 'assets/images/home.png',
              isActive: currentIdx == 0,
              label: 'Home',
              onTap: () {
                ensureBinding(0);
                setState(() => currentIdx = 0);
              },
            ),
            navButton(
              image: 'assets/images/recipe.png',
              isActive: currentIdx == 1,
              label: 'Recipe',
              onTap: () {
                ensureBinding(1);
                setState(() => currentIdx = 1);
              },
            ),
            navButton(
              image: 'assets/images/music.png',
              isActive: currentIdx == 2,
              label: 'Music',
              onTap: () {
                ensureBinding(2);
                setState(() => currentIdx = 2);
              },
            ),
            navButton(
              image: 'assets/images/calculator.png',
              isActive: currentIdx == 3,
              label: 'Calc.',
              onTap: () {
                ensureBinding(3);
                setState(() => currentIdx = 3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
