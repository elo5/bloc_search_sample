import 'package:bloc_search_sample/bloc/bloc_provicer.dart';
import 'package:bloc_search_sample/utils/log_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_search_sample/model/search_response.dart';
import 'package:bloc_search_sample/data_fetch_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchStatus {
  static const int BEFORESEARCH = 1;
  static const int AFTERSEARCHNORESULT = 2;
  static const int AFTERSEARCHWITHRESULT = 3;
}

class SearchBloc implements BlocBase {

  List<SearchItems> resultList;
  String _searchStr = '';
  String _pageToken = '';
  final String TAG = "SEARCH BLOC";
  final String HISTORY_TAG = "SEARCH_HISTORY";

  DataFetchAPI dataFetchApi = new DataFetchAPI();

  SearchBloc() {
    LogUtil.e("****** SearchBloc ******", tag: TAG);
  }

  BehaviorSubject<SearchResponse> _searchData = BehaviorSubject<SearchResponse>();
  Sink<SearchResponse> get _searchDataSink => _searchData.sink;
  Stream<SearchResponse> get searchDataStream => _searchData.stream;

  BehaviorSubject<int> _searchStatus = BehaviorSubject<int>();
  Sink<int> get _searchStatusSink => _searchStatus.sink;
  Stream<int> get searchStatusStream => _searchStatus.stream;

  BehaviorSubject<List<String>> _searchHistory =  BehaviorSubject<List<String>>();
  Sink<List<String>> get _searchHistorySink => _searchHistory.sink;
  Stream<List<String>> get searchHistoryStream => _searchHistory.stream;

  Future onLoadMore() {
    if (resultList == null) resultList = new List();
    else resultList.clear();
    return getSearchResult( _searchStr);
  }

  Future onRefresh() {
    _pageToken = '';
    return getSearchResult( _searchStr);
  }

  Future getSearchResult(String searchString) async {
    if(searchString != _searchStr){
      if (resultList == null) resultList = new List();
      else resultList.clear();
      _pageToken = '';
    }
    LogUtil.e(" searchString: $searchString   _pageToken: $_pageToken ",  tag: TAG);
    _searchStr = searchString;
    _addToSearchHistory(searchString);

    return dataFetchApi
        .getSearchResult(query: searchString,pageToken: _pageToken)
        .then((response) {

      _pageToken = response.nextPageToken;
      if (resultList == null) resultList = new List();
      resultList.addAll(response.items);
      if (resultList.length > 0)
        _searchStatusSink.add(SearchStatus.AFTERSEARCHWITHRESULT);
      else
        _searchStatusSink.add(SearchStatus.AFTERSEARCHNORESULT);
      _searchDataSink.add(response);
    }).catchError((error) {
      LogUtil.e("error?? $error", tag: TAG);
      _searchStatusSink.add(SearchStatus.AFTERSEARCHNORESULT);
    });
  }

  void getSearchHistory() {
    _addToSearchHistory('');
  }

  void clearSearchHistory() {
    _addToSearchHistory('', clear: true);
  }

  void _addToSearchHistory(String searchStr, {bool clear = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (clear) {
      prefs.setStringList(HISTORY_TAG, []);
      return _searchHistorySink.add([]);
    }

    List<String> historyStrings =
        prefs.getStringList(HISTORY_TAG) ?? [];
    if (searchStr.length != 0) {
      if (historyStrings.length == 0) {
        historyStrings.add(searchStr);
      } else {
        bool alreadyHas = false;
        for (int i = 0; i < historyStrings.length; i++) {
          if (historyStrings[i].toString() == searchStr) {
            historyStrings.remove(historyStrings[i]);
            historyStrings.insert(0, searchStr);
            alreadyHas = true;
          }
        }
        if (!alreadyHas) historyStrings.insert(0, searchStr);
        if (historyStrings.length > 10)
          historyStrings.removeAt(historyStrings.length - 1);
      }
      await prefs.setStringList(HISTORY_TAG, historyStrings);
    }
    _searchHistorySink.add(historyStrings);
  }

  void clearSearchTF() {
    _searchStatusSink.add(SearchStatus.BEFORESEARCH);
  }

  @override
  void dispose() {
    _searchData.close();
    _searchStatusSink.close();
  }
}
