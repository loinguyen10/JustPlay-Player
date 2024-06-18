import 'package:flutter/material.dart';
import 'package:flutter_justplay_player/api/youtube_api.dart';
import 'package:flutter_justplay_player/plugin/youtube/youtube_data_api/youtube_data_api.dart';

class YoutubeSearchViewModel extends ChangeNotifier {
  final youtubeDataApi = YoutubeDataApi();
  final api = YoutubeAPI();
  List result = [];
  bool isLoading = false;
  List<String> autoComplete = [];
  // bool empty = true;
  final focusNode = FocusNode();

  final searchTextController = TextEditingController();
  String lastSearch = '';

  final scrollController = ScrollController();

  Future<void> search() async {
    try {
      isLoading = true;
      print('Searching...');
      List videoResult = await youtubeDataApi.fetchSearchVideo(searchTextController.text, '');
      result = videoResult;
      lastSearch = searchTextController.text;
    } catch (e) {
      searchTextController.text = lastSearch;
      print('search youtube: $e');
    } finally {
      scrollController.jumpTo(0);
      isLoading = false;
      print('Done');
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    try {
      // isLoading = true;
      print('Loading more...');
      List videoResult = await youtubeDataApi.fetchSearchVideo(lastSearch, '');
      videoResult.forEach((e) {
        if (!result.contains(e)) result.add(e);
      });
      // result.addAll(videoResult);
    } catch (e) {
      print('load more youtube: $e');
    } finally {
      // isLoading = false;
      print('Done');
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
    var getSuggestions = await youtubeDataApi.fetchSuggestions(searchTextController.text);
    autoComplete = getSuggestions;
    // if (autoComplete.isNotEmpty) empty = false;
    notifyListeners();
  }
}
