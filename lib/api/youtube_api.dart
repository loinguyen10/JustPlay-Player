import 'package:flutter_chocolatecookies/service/base_api.dart';

class YoutubeAPI extends BaseApi {
  Future<ApiResponse> autoCompleteSuggestions(String text) async {
    final getSuggestions = await api.get(url: 'http://suggestqueries.google.com/complete/search?client=youtube&ds=yt&client=firefox&q=$text');
    return getSuggestions;
  }
}
