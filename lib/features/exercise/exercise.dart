import 'dart:io';

import 'package:fit_and_fuel/features/exercise/controller/controller.dart';
import 'package:fit_and_fuel/features/exercise/model/model.dart' as model;
import 'package:fit_and_fuel/features/widgets/nav_button.dart';
import 'package:fit_and_fuel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';

class Exercise extends StatefulWidget {
  const Exercise({super.key});

  @override
  State<Exercise> createState() => ExerciseState();
}

class ExerciseState extends State<Exercise> {
  final exerciseController = Get.find<ExerciseController>();
  String part = '';
  List<model.ExerciseModel> exercises = [];
  List<model.ExerciseModel> filteredExercises = [];
  List<model.MuscleModel> muscles = [];
  List<String> equipments = [
    'Dumbbell',
    'Barbell',
    'Machine',
    'Cable',
    'Bodyweight',
  ];
  final Map<String, Future<Uint8List?>> thumbnailCache = {};
  final Map<String, String> materializedVideos = {};
  VideoPlayerController? videoController;
  int? playingIndex, loadingIndex;
  String selectedEquipment = '', selectedMuscle = '';

  @override
  void initState() {
    super.initState();
    part = Get.arguments;
    exerciseController.loadMuscleData(part);
    exerciseController.loadExerciseData(part);
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  void filter() {
    filteredExercises =
        exercises.where((e) {
          final muscleMatch =
              selectedMuscle.isEmpty
                  ? true
                  : e.muscle?.contains(selectedMuscle) ?? false;
          final equipmentMatch =
              selectedEquipment.isEmpty
                  ? true
                  : e.equipment == selectedEquipment;
          return muscleMatch && equipmentMatch;
        }).toList();
  }

  Future<String?> materializeVideoAsset(String assetPath) async {
    if (assetPath.isEmpty) return null;
    final cachedPath = materializedVideos[assetPath];
    if (cachedPath != null && await File(cachedPath).exists()) {
      return cachedPath;
    }

    final dir = await getTemporaryDirectory();
    final filename = assetPath.split('/').last;
    final file = File('${dir.path}/exercise_$filename');
    if (!await file.exists()) {
      final bytes = await rootBundle.load(assetPath);
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }

    materializedVideos[assetPath] = file.path;
    return file.path;
  }

  Future<Uint8List?> loadThumbnail(String assetPath) {
    return thumbnailCache.putIfAbsent(assetPath, () async {
      try {
        final videoPath = await materializeVideoAsset(assetPath);
        if (videoPath == null) return null;
        return VideoThumbnail.thumbnailData(
          video: videoPath,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 720,
          quality: 60,
          timeMs: 800,
        );
      } catch (e) {
        debugPrint('[Log] Thumbnail generation failed for $assetPath: $e');
        return null;
      }
    });
  }

  Widget buildThumbnail(String videoAsset) {
    if (videoAsset.trim().isEmpty || videoAsset == 'null') {
      return thumbnailFallback();
    }

    return FutureBuilder<Uint8List?>(
      future: loadThumbnail(videoAsset),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Color(0xFF181A20),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFFCD535),
            ),
          );
        }

        final bytes = snapshot.data;
        if (bytes == null || bytes.isEmpty) {
          return thumbnailFallback();
        }

        return Image.memory(
          bytes,
          colorBlendMode: BlendMode.lighten,
          color: Color(0xFF181A20),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      },
    );
  }

  Widget thumbnailFallback() {
    return Container(
      color: Color(0x25D9D9D9),
      alignment: Alignment.center,
      child: Image.asset('assets/images/logo1.png', height: 75),
    );
  }

  Future<void> stopPlayback({bool refreshUi = true}) async {
    loadingIndex = null;
    playingIndex = null;
    final controller = videoController;
    videoController = null;
    if (controller != null) {
      await controller.pause();
      await controller.dispose();
    }
    if (mounted && refreshUi) {
      setState(() {});
    }
  }

  Future<void> togglePlayback({
    required int index,
    required String videoAsset,
  }) async {
    if (videoAsset.isEmpty) return;

    if (playingIndex == index && videoController != null) {
      await stopPlayback();
      return;
    }

    setState(() {
      loadingIndex = index;
    });

    try {
      final videoPath = await materializeVideoAsset(videoAsset);
      if (videoPath == null) {
        if (mounted) {
          setState(() {
            loadingIndex = null;
          });
        }
        return;
      }

      final nextController = VideoPlayerController.file(File(videoPath));
      await nextController.initialize();
      await nextController.setLooping(true);
      await nextController.play();

      final oldController = videoController;
      videoController = nextController;
      playingIndex = index;
      loadingIndex = null;

      if (oldController != null) {
        await oldController.pause();
        await oldController.dispose();
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('[Log] Video playback failed for $videoAsset: $e');
      await stopPlayback(refreshUi: false);
      if (mounted) {
        setState(() {
          loadingIndex = null;
        });
      }
    }
  }

  Widget buildMedia({required int index, required String videoAsset}) {
    final isCurrentVideo =
        playingIndex == index &&
        videoController != null &&
        videoController!.value.isInitialized;

    if (isCurrentVideo) {
      final size = videoController!.value.size;
      return ClipRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: VideoPlayer(videoController!),
            ),
          ),
        ),
      );
    }

    if (loadingIndex == index) {
      return Container(
        color: Color(0xFF181A20),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFFFCD535),
        ),
      );
    }

    return buildThumbnail(videoAsset);
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF181A20),
            elevation: 8,
            surfaceTintColor: Colors.transparent,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:
                      () => Get.offAllNamed(
                        MyRoutes.shellRoute,
                        arguments: {'idx': 0},
                      ),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0x3ED9D9D9)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                      color: Color(0x7ED9D9D9),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      part,
                      style: TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35, width: 35),
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (exerciseController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFFCD535)),
            );
          }

          exercises = exerciseController.exercises;
          muscles = exerciseController.muscles;
          filter();
          if (playingIndex != null &&
              playingIndex! >= filteredExercises.length) {
            stopPlayback(refreshUi: false);
          }
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                if (part != 'Cardio') ...[
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: muscles.length + 1,
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return filterButton(
                            color:
                                selectedMuscle == ''
                                    ? Color(0xFFFCD535)
                                    : Color(0x13D9D9D9),
                            label: ' All ',
                            labelColor:
                                selectedMuscle == ''
                                    ? Color(0xFF181A20)
                                    : Color(0xFFD9D9D9),
                            onPressed: () {
                              setState(() {
                                selectedMuscle = '';
                                filter();
                              });
                            },
                          );
                        }
                        final m = muscles[index - 1];
                        final isSelected = selectedMuscle == m.muscle;
                        return filterButton(
                          color:
                              isSelected
                                  ? Color(0xFFFCD535)
                                  : Color(0x13D9D9D9),
                          label: ' ${m.muscle} ',
                          labelColor:
                              isSelected
                                  ? Color(0xFF181A20)
                                  : Color(0xFFD9D9D9),
                          onPressed: () {
                            setState(() {
                              selectedMuscle = m.muscle ?? '';
                              filter();
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: equipments.length + 1,
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return filterButton(
                            color:
                                selectedEquipment == ''
                                    ? Color(0xFFFCD535)
                                    : Color(0x13D9D9D9),
                            label: ' All ',
                            labelColor:
                                selectedEquipment == ''
                                    ? Color(0xFF181A20)
                                    : Color(0xFFD9D9D9),
                            onPressed: () {
                              setState(() {
                                selectedEquipment = '';
                                filter();
                              });
                            },
                          );
                        }
                        final e = equipments[index - 1];
                        final isSelected = selectedEquipment == e;
                        return filterButton(
                          color:
                              isSelected
                                  ? Color(0xFFFCD535)
                                  : Color(0x13D9D9D9),
                          label: ' $e ',
                          labelColor:
                              isSelected
                                  ? Color(0xFF181A20)
                                  : Color(0xFFD9D9D9),
                          onPressed: () {
                            setState(() {
                              selectedEquipment = e;
                              filter();
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                if (filteredExercises.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Text(
                        'No Exercises available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0x80D9D9D9),
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredExercises.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final e = filteredExercises[index];
                      return exerciseCard(index: index, e: e);
                    },
                  ),
              ],
            ),
          );
        }),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x0BD9D9D9),
              border: Border.all(width: 1, color: Color(0x18D9D9D9)),
              borderRadius: BorderRadius.circular(38),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navButton(
                  image: 'assets/images/home.png',
                  isActive: true,
                  label: 'Home',
                  onTap: () {
                    Get.offAllNamed(MyRoutes.shellRoute, arguments: {'idx': 0});
                  },
                ),
                navButton(
                  image: 'assets/images/recipe.png',
                  isActive: false,
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

  Widget filterButton({
    required Color color,
    required String label,
    required Color labelColor,
    required VoidCallback? onPressed,
  }) {
    return Container(
      constraints: BoxConstraints.tightFor(height: 40),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: onPressed,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              height: 1,
              fontSize: 18,
              color: labelColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget exerciseCard({required int index, required model.ExerciseModel e}) {
    final isActive = playingIndex == index;
    final hasVideo =
        e.asset != null && e.asset!.trim().isNotEmpty && e.asset != 'null';
    debugPrint('[Log] Asset value: "${e.asset}"');

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0x0BD9D9D9),
        border: Border.all(width: 1, color: Color(0x3ED9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () async {
          if (!hasVideo) return;

          final isPlayingThisItem =
              playingIndex == index && videoController != null;

          if (isPlayingThisItem) {
            await stopPlayback();
          } else {
            await togglePlayback(index: index, videoAsset: e.asset ?? '');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: buildMedia(index: index, videoAsset: e.asset ?? ''),
                  ),
                  if (e.muscle != null && e.muscle != '')
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xBE181A20),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${e.muscle}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                    ),
                  if (hasVideo)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Row(
                        children: [
                          Icon(
                            isActive
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 35,
                            color:
                                isActive
                                    ? Color(0xFFFCD535)
                                    : Color(0xFFD9D9D9),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          e.name ?? 'N/A',
                          style: TextStyle(
                            height: 1.25,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0x3ED9D9D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(7.5),
                        child: Text(
                          '${e.equipment}',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xBED9D9D9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF181A20),
                      border: Border.all(width: 1, color: Color(0x3ED9D9D9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Execution',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              isActive
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFFD9D9D9),
                            ),
                          ],
                        ),
                        if (isActive) ...[
                          SizedBox(height: 5),
                          Text(
                            e.desc ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
