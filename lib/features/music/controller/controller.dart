import 'dart:async';
import 'package:fit_and_fuel/features/music/model/model.dart';
import 'package:fit_and_fuel/features/music/service/service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MusicController extends GetxController {
  RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;
  RxList<SongModel> songs = <SongModel>[].obs;
  RxBool isLoading = false.obs, isSongOn = false.obs;
  final player = AudioPlayer();
  final currentPlaylistId = RxnInt();
  final currentPlaylistSongIds = <int>[].obs;
  final currentSong = Rx<SongModel?>(null);
  final currentIdxInPlaylist = RxnInt();
  StreamSubscription<int?>? idxSub;
  StreamSubscription<PlayerState>? playerStateSub;
  StreamSubscription<bool>? playingSub;
  StreamSubscription? sequenceStateSub;

  @override
  void onReady() {
    super.onReady();
    setupPlayerListeners();
    loadMusicData();
  }

  void setupPlayerListeners() {
    playingSub = player.playingStream.listen((playing) {
      isSongOn.value = playing;
    });
    idxSub = player.currentIndexStream.listen((idx) {
      currentIdxInPlaylist.value = idx;
      updateCurrentSongFromIndex(idx);
    });
    playerStateSub = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isSongOn.value = false;
      }
    });
    sequenceStateSub = player.sequenceStateStream.listen((state) {
      final tag = state.currentSource?.tag;
      if (tag is MediaItem) {
        final id = tag.extras?['songId'];
        if (id != null) {
          final song = getSongById(id);
          if (song != null) currentSong.value = song;
        }
      }
    });
  }

  void updateCurrentSongFromIndex(int? idx) {
    if (idx == null) {
      currentSong.value = null;
      return;
    }
    if (currentPlaylistSongIds.isNotEmpty &&
        idx >= 0 &&
        idx < currentPlaylistSongIds.length) {
      currentSong.value = getSongById(currentPlaylistSongIds[idx]);
    } else {
      currentSong.value = null;
    }
  }

  SongModel? getSongById(int id) {
    try {
      return songs.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    idxSub?.cancel();
    playerStateSub?.cancel();
    playingSub?.cancel();
    sequenceStateSub?.cancel();
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
      debugPrint('[Log] loadMusicData error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
