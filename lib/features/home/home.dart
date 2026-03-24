import 'dart:math';
import 'package:fit_and_fuel/features/home/controller/controller.dart';
import 'package:fit_and_fuel/features/home/model/model.dart' as model;
import 'package:fit_and_fuel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final homeController = Get.find<HomeController>();
  List<model.QuoteModel> quotes = [];
  List<model.ExerciseHomeModel> exercises = [];
  String? photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181A20),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFFCD535)),
          );
        }

        quotes = homeController.quotes;
        exercises = homeController.exercises;
        final random = Random();
        final randomQuote =
            quotes.isNotEmpty ? quotes[random.nextInt(quotes.length)] : null;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Text(
                        'DAILY MOTIVATION',
                        style: TextStyle(
                          height: 1,
                          letterSpacing: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          foreground:
                              Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1.1
                                ..color = Color(0x7ED9D9D9),
                        ),
                      ),
                      Text(
                        'DAILY MOTIVATION',
                        style: TextStyle(
                          height: 1,
                          letterSpacing: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0x7ED9D9D9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 7.5),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0x00D9D9D9),
                      Color(0x0BD9D9D9),
                      Color(0x13D9D9D9),
                    ],
                    stops: [0, 0.9, 1],
                  ),
                  border: Border.all(width: 0.5, color: Color(0x3ED9D9D9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '"${randomQuote?.quote}"',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (randomQuote?.author != null) ...[
                      SizedBox(height: 7.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '~ ${randomQuote?.author}',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFCD535),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Stack(
                    children: [
                      Text(
                        'Workouts',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          foreground:
                              Paint()
                                ..style = PaintingStyle.stroke
                                ..color = Color(0xFFD9D9D9),
                        ),
                      ),
                      Text(
                        'Workouts',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 7.5),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return workoutCard(exercise: exercise);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget workoutCard({required model.ExerciseHomeModel exercise}) {
    return Container(
      height: 200,
      child: GestureDetector(
        onTap: () {
          final part = '${exercise.part}';
          Get.offAllNamed(MyRoutes.exerciseRoute, arguments: part);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(int.parse('0xFF${exercise.bgColor}')),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  '${exercise.image}',
                  color: Color(0xBE181A20),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x00181A20),
                        Color(0x3E181A20),
                        Color(0x7E181A20),
                        Color(0xBE181A20),
                        Color(0xFF181A20),
                      ],
                      stops: [0, 0.25, 0.75, 0.9, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0x3ED9D9D9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${exercise.symbol?.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD9D9D9),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: Stack(
                  children: [
                    Text(
                      '${exercise.part}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        foreground:
                            Paint()
                              ..style = PaintingStyle.stroke
                              ..color = Color(0xFFD9D9D9),
                      ),
                    ),
                    Text(
                      '${exercise.part}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
