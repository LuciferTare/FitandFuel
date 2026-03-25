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
  RxBool isLoading = false.obs;
  final AudioPlayer player = AudioPlayer();

  // Playback state — lives here so it survives page navigation
  final RxnInt currentPlaylistId = RxnInt();
  final RxList<int> currentPlaylistSongIds = <int>[].obs;
  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  final RxBool isSongOn = false.obs;
  final RxnInt currentIdxInPlaylist = RxnInt();

  StreamSubscription<int?>? _idxSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription? _sequenceStateSub;

  @override
  void onReady() {
    super.onReady();
    _setupPlayerListeners();
    loadMusicData();
  }

  void _setupPlayerListeners() {
    _playingSub = player.playingStream.listen((playing) {
      isSongOn.value = playing;
    });
    _idxSub = player.currentIndexStream.listen((idx) {
      currentIdxInPlaylist.value = idx;
      _updateCurrentSongFromIndex(idx);
    });
    _playerStateSub = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isSongOn.value = false;
      }
    });
    _sequenceStateSub = player.sequenceStateStream.listen((state) {
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

  void _updateCurrentSongFromIndex(int? idx) {
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
    _idxSub?.cancel();
    _playerStateSub?.cancel();
    _playingSub?.cancel();
    _sequenceStateSub?.cancel();
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
