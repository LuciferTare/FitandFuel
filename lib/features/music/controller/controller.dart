import 'package:fit_and_fuel/features/music/model/model.dart';
import 'package:fit_and_fuel/features/music/service/service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicController extends GetxController {
  RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;
  RxList<SongModel> songs = <SongModel>[].obs;
  RxBool isLoading = false.obs;
  final AudioPlayer player = AudioPlayer();

  @override
  void onReady() {
    super.onReady();
    loadMusicData();
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  Future<void> loadMusicData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        MusicService().getPlaylistsData(),
        MusicService().getSongsData(),
      ]);
      playlists.assignAll(results[0] as List<PlaylistModel>);
      songs.assignAll(results[1] as List<SongModel>);
    } catch (e) {
      debugPrint('[LOG] $e');
    } finally {
      isLoading.value = false;
    }
  }
}
