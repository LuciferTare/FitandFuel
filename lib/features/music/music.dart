import 'dart:io';
import 'package:fit_and_fuel/features/widgets/custom_textfields.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:fit_and_fuel/features/music/controller/controller.dart';
import 'package:fit_and_fuel/features/music/model/model.dart' as model;
import 'package:fit_and_fuel/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class Music extends StatefulWidget {
  const Music({super.key});

  @override
  State<Music> createState() => MusicState();
}

class MusicState extends State<Music> {
  final musicController = Get.find<MusicController>();
  final searchC = TextEditingController();
  final searchFN = FocusNode();
  int? expandedIdx;
  AudioPlayer get player => musicController.player;
  final Map<String, String> assetFileCache = {};

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

  void onPlaylistPlayTap(model.PlaylistModel playlist) async {
    final int? playlistId = playlist.id;
    if (playlistId == null) return;
    if (musicController.currentPlaylistId.value != playlistId) {
      await loadPlaylistIntoPlayer(playlist, startIndex: 0, autoPlay: true);
      return;
    }
    try {
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
    } catch (err) {
      debugPrint('[LOG] Failed to resume playback: $err');
    }
  }

  void togglePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void skipNext() async {
    try {
      if (player.hasNext) await player.seekToNext();
    } catch (err) {
      debugPrint('[LOG] skipNext error: $err');
    }
  }

  void skipPrevious() async {
    try {
      if (player.hasPrevious) await player.seekToPrevious();
    } catch (err) {
      debugPrint('[LOG] skipPrevious error: $err');
    }
  }

  Future<void> loadPlaylistIntoPlayer(
    model.PlaylistModel playlist, {
    int startIndex = 0,
    bool autoPlay = true,
  }) async {
    final ids = playlist.songIds ?? [];
    if (ids.isEmpty) {
      debugPrint('[LOG] Playlist contains no song ids.');
      return;
    }
    final orderedSongs = ids
        .map((id) => musicController.getSongById(id))
        .whereType<model.SongModel>()
        .toList();
    if (orderedSongs.isEmpty) {
      debugPrint('[LOG] No matching songs found for playlist ${playlist.title}');
      return;
    }
    final List<AudioSource> sources = [];
    for (final song in orderedSongs) {
      final assetPath = song.asset ?? '';
      if (assetPath.isEmpty) continue;
      final encodedPath = Uri.encodeFull(assetPath);
      final uri = Uri.parse('asset:///$encodedPath');
      final mediaItem = await mediaItemFromSong(song);
      sources.add(AudioSource.uri(uri, tag: mediaItem));
    }
    if (sources.isEmpty) {
      debugPrint('[LOG] No valid audio sources for playlist ${playlist.title}');
      return;
    }
    try {
      await player.stop();
      await player.setAudioSources(
        sources,
        initialIndex: startIndex,
        initialPosition: Duration.zero,
      );
      musicController.currentPlaylistId.value = playlist.id;
      musicController.currentPlaylistSongIds.assignAll(ids);
      musicController.currentIdxInPlaylist.value = startIndex;
      musicController.currentSong.value =
          orderedSongs.length > startIndex
              ? orderedSongs[startIndex]
              : orderedSongs.first;
      if (autoPlay) await player.play();
    } catch (e) {
      debugPrint('[LOG] Error loading playlist: $e');
    }
  }

  bool isPlaylistActive(int? playlistId) {
    if (playlistId == null) return false;
    return musicController.currentPlaylistId.value == playlistId;
  }

  Future<MediaItem> mediaItemFromSong(model.SongModel song) async {
    final artUri = await artUriFromAsset(song.thumb ?? '');
    return MediaItem(
      id: song.asset ?? '',
      title: song.title ?? 'Unknown',
      artist: song.artist ?? 'Unknown',
      artUri: artUri,
      extras: {'songId': song.id, 'asset': song.asset},
    );
  }

  Future<Uri> artUriFromAsset(String assetPath) async {
    if (assetPath.isEmpty)
      return Uri.parse('asset:///assets/audio-thumb/default.png');
    final cached = assetFileCache[assetPath];
    if (cached != null && await File(cached).exists()) {
      return Uri.file(cached);
    }
    try {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final filename = 'art_${p.basename(assetPath)}';
      final file = File(p.join(dir.path, filename));
      await file.writeAsBytes(bytes, flush: true);
      assetFileCache[assetPath] = file.path;
      return Uri.file(file.path);
    } catch (e) {
      debugPrint('[LOG] artUriFromAsset error for $assetPath: $e');
      return Uri.parse('asset:///$assetPath');
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
      child: Obx(() {
        if (musicController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFFCD535)),
          );
        }

        final playlists = musicController.playlists;
        final cs = musicController.currentSong.value;
        final query = searchC.text.trim().toLowerCase();
        final displayPlaylists =
            query.isEmpty
                ? playlists
                : playlists
                    .where(
                      (r) => r.title?.toLowerCase().contains(query) ?? false,
                    )
                    .toList();
        final titleText =
            displayPlaylists.isEmpty && query.isNotEmpty
                ? 'No Featured Playlists'
                : 'Featured Playlists';

        return Scaffold(
          backgroundColor: Color(0xFF181A20),
          body: SingleChildScrollView(
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayPlaylists.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final playlist = displayPlaylists[idx];
                    return playlistCard(playlist, idx);
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              cs == null
                  ? null
                  : Container(
                    decoration: BoxDecoration(
                      color: Color(0x0BD9D9D9),
                      border: Border.all(width: 1, color: Color(0x18D9D9D9)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.fromLTRB(12.5, 10, 10, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                cs.thumb ?? 'assets/audio-thumb/default.png',
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 7.5),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cs.title ?? 'Unknown',
                                    style: TextStyle(
                                      height: 1.1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD9D9D9),
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                          color: Color(0xFF181A20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    cs.artist ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0x7ED9D9D9),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 7.5),
                            GestureDetector(
                              onTap: skipPrevious,
                              child: Icon(
                                Icons.skip_previous_outlined,
                                size: 30,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            GestureDetector(
                              onTap: togglePlayPause,
                              child: Icon(
                                musicController.isSongOn.value
                                    ? Icons.pause_outlined
                                    : Icons.play_arrow_outlined,
                                size: 30,
                                color: Color(0xFFFCD535),
                              ),
                            ),
                            GestureDetector(
                              onTap: skipNext,
                              child: Icon(
                                Icons.skip_next_outlined,
                                size: 30,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: StreamBuilder<Duration>(
                            stream: player.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              final duration = player.duration ?? Duration.zero;

                              final progress =
                                  duration.inMilliseconds > 0
                                      ? (position.inMilliseconds /
                                              duration.inMilliseconds)
                                          .clamp(0.0, 1.0)
                                      : 0.0;

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 2,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFCD535),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      }),
    );
  }

  Widget playlistCard(model.PlaylistModel playlist, int idx) {
    final id = playlist.id;
    final icon = '${playlist.icon}';
    final cover = '${playlist.cover}';
    final color = '${playlist.color}';
    final title = '${playlist.title}';
    final sIDs = playlist.songIds ?? [];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[5],
        border: Border.all(
          color: isPlaylistActive(id) ? Color(0x3EFCD535) : Color(0x3ED9D9D9),
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() => expandedIdx = expandedIdx == idx ? null : idx);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(cover, fit: BoxFit.cover),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x3E181A20),
                                Color(0x7E181A20),
                                Color(0xBE181A20),
                                Color(0xFF181A20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 70,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 22,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Color(int.parse('0xFF$color')),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Image.asset(
                                icon,
                                height: 32,
                                width: 32,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Stack(
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    foreground:
                                        Paint()
                                          ..style = PaintingStyle.stroke
                                          ..color =
                                              isPlaylistActive(id)
                                                  ? Color(0xFFFCD535)
                                                  : Color(0xFFD9D9D9),
                                  ),
                                ),
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        isPlaylistActive(id)
                                            ? Color(0xFFFCD535)
                                            : Color(0xFFD9D9D9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () => onPlaylistPlayTap(playlist),
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      isPlaylistActive(id) &&
                                              musicController.isSongOn.value
                                          ? Color(0xBEFCD535)
                                          : Color(0xBED9D9D9),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(2.5),
                              child: Center(
                                child: Image.asset(
                                  isPlaylistActive(id) &&
                                          musicController.isSongOn.value
                                      ? 'assets/images/pause.png'
                                      : 'assets/images/play.png',
                                  fit: BoxFit.contain,
                                  color:
                                      isPlaylistActive(id)
                                          ? Color(0xBEFCD535)
                                          : Color(0xBED9D9D9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (expandedIdx == idx)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color:
                                  isPlaylistActive(id)
                                      ? Color(0x3EFCD535)
                                      : Color(0x3ED9D9D9),
                            ),
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sIDs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemBuilder: (context, sId) {
                            final songId = sIDs[sId];
                            final song = musicController.getSongById(songId);
                            final songTitle = song?.title ?? 'Untitled';
                            final isActive =
                                isPlaylistActive(id) &&
                                musicController.currentIdxInPlaylist.value ==
                                    sId;
                            return InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                if (isPlaylistActive(id)) {
                                  await player.seek(Duration.zero, index: sId);
                                  if (!player.playing) await player.play();
                                } else {
                                  await loadPlaylistIntoPlayer(
                                    playlist,
                                    startIndex: sId,
                                    autoPlay: true,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    child:
                                        isActive
                                            ? Center(
                                              child: Icon(
                                                Icons.equalizer,
                                                size: 18,
                                                color: Color(0xFFFCD535),
                                              ),
                                            )
                                            : Center(
                                              child: Text(
                                                '${sId + 1}',
                                                style: TextStyle(
                                                  height: 1,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0x7ED9D9D9),
                                                ),
                                              ),
                                            ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      songTitle,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color:
                                            isActive
                                                ? Color(0xFFFCD535)
                                                : Color(0xFFD9D9D9),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Color(0x7E000000),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
