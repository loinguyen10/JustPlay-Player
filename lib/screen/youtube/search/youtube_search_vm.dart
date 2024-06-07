import 'package:flutter/material.dart';
import 'package:flutter_justplay_player/api/youtube_api.dart';
import 'package:flutter_justplay_player/plugin/youtube/youtube_data_api/youtube_data_api.dart';

class YoutubeSearchViewModel extends ChangeNotifier {
  YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  final api = YoutubeAPI();
  List result = [];
  final searchWordController = TextEditingController();
  bool isLoading = false;
  List<String> autoComplete = [];
  bool empty = true;

  Future<void> search() async {
    try {
      isLoading = true;
      List videoResult = await youtubeDataApi.fetchSearchVideo('hk15', '');
      result = videoResult;
    } catch (e) {
      print('search youtube: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> autoCompleteSuggestions() async {
    // try {
    //   var getSuggestions = await api.autoCompleteSuggestions('hk15');
    //   final List extractedData = getSuggestions.bodyJson as List<dynamic>;
    //   autoComplete = extractedData;
    //   if (autoComplete.isNotEmpty) empty = false;

    // } catch (e) {
    //   print('autoCompleteSuggestions youtube: $e');
    // } finally {
    //   notifyListeners();
    // }
    var getSuggestions = await youtubeDataApi.fetchSuggestions('hk15');
    autoComplete = getSuggestions;
    if (autoComplete.isNotEmpty) empty = false;
    notifyListeners();
  }
}
