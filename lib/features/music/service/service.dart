import 'dart:convert';
import 'package:fit_and_fuel/features/music/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MusicService {
  Future<List<PlaylistModel>> getPlaylistsData() async {
    try {
      // var res = await Get.find<ApiClient>().getRequest<QuoteModel>('/api/qoutes/', isAuth: true);
      // var data = (res.data as List).map((item) => QuoteModel.fromJson(item as Map<String, dynamic>)).toList();
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
      // var res = await Get.find<ApiClient>().getRequest<ExerciseHomeModel>('/api/exercise-home/', isAuth: true,);
      // var data = (res.data as List).map((item) => ExerciseHomeModel.fromJson(item as Map<String, dynamic>),).toList();
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
