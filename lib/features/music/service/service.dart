import 'dart:convert';
import 'package:fit_and_fuel/features/music/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MusicService {
  Future<List<PlaylistModel>> getPlaylistsData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/playlists.json',
      );
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data =
          jsonData.map((item) => PlaylistModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getPlaylistsData error: $e');
      rethrow;
    }
  }

  Future<List<SongModel>> getSongsData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/songs.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final data = jsonData.map((item) => SongModel.fromJson(item)).toList();

      return data;
    } catch (e) {
      debugPrint('[LOG] getSongsData error: $e');
      rethrow;
    }
  }
}
