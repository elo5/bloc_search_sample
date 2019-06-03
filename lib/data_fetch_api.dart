import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:bloc_search_sample/model/search_response.dart';
import 'package:bloc_search_sample/utils/log_util.dart';

var dio = Dio();
const int MAX_SEARCH_RESULTS = 5;
const String API_KEY = 'YOUR_KEY';
const String DATA_FETCH_TAG = 'DATA_FETCH_TAG';

class DataFetchAPI {

  final String BASE_URL_SEARCH =
      'https://www.googleapis.com/youtube/v3/search?part=snippet' +
          '&maxResults=$MAX_SEARCH_RESULTS&type=video&key=$API_KEY';

  final String BASE_URL_VIDEO =
      'https://www.googleapis.com/youtube/v3/videos?part=snippet&key=$API_KEY';

  Future<SearchResponse> getSearchResult({ String query, String pageToken = ''}) async {

    LogUtil.e(BASE_URL_SEARCH +  '&q=$query' +
        (pageToken.isNotEmpty ? '&pageToken=$pageToken' : ''), tag: DATA_FETCH_TAG);

    var response = await dio.get(BASE_URL_SEARCH +  '&q=$query' +
        (pageToken.isNotEmpty ? '&pageToken=$pageToken' : '') );
    LogUtil.e(response.toString(), tag: DATA_FETCH_TAG);
    return SearchResponse.fromJson(json.decode(response.toString()));
  }
}
