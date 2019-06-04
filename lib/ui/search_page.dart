import 'package:flutter/material.dart';
import 'package:bloc_search_sample/bloc/search_bloc.dart';
import 'package:bloc_search_sample/bloc/bloc_provicer.dart';
import 'package:bloc_search_sample/utils/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bloc_search_sample/model/search_response.dart';
import 'package:bloc_search_sample/res/styles.dart';
import 'package:bloc_search_sample/res/colours.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_search_sample/ui/empty_view.dart';

final Key _searchKey = new GlobalKey(debugLabel: 'search_key');

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.initialSearchStr}) : super(key: key);
  final String initialSearchStr;

  @override
  SearchPageState createState() {
    return SearchPageState(initialSearchStr: initialSearchStr);
  }
}

class SearchPageState extends State<SearchPage> {
  final String initialSearchStr;

  SearchPageState({this.initialSearchStr});

  final RefreshController _refreshController = new RefreshController();
  final _textController = TextEditingController();
  SearchBloc searchBloc;
  bool hasSearchPageInit = false;
  final String TAG = "SEARCH PAGE";
  bool isPullDown = false;

  void _onLoading() {
    isPullDown = false;
    searchBloc.onLoadMore();
  }

  void _onRefresh() {
    isPullDown = true;
    searchBloc.onRefresh();
  }

  void dispose() {
    searchBloc.clearSearchTF();
    searchBloc.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasSearchPageInit) {
      hasSearchPageInit = true;
      _textController.value =
          new TextEditingValue(text: initialSearchStr ?? '');
      searchBloc = BlocProvider.of<SearchBloc>(context);
      searchBloc.getSearchHistory();
    }

    return WillPopScope(
        onWillPop: () async {
          dispose();
          return true;
        },
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0.0,
                  title: _buildAppBar(context),
                  actions: <Widget>[],
                ),
                body: new StreamBuilder(
                    stream: searchBloc.searchStatusStream,
                    initialData: SearchStatus.BEFORESEARCH,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.data == SearchStatus.BEFORESEARCH) {
                        LogUtil.e("snapshot.data == SearchStatus.BEFORESEARCH",
                            tag: TAG);

                        return new StreamBuilder(
                            stream: searchBloc.searchHistoryStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> snapshot) {
                              return _buildHistory(context, snapshot.data);
                            });
                      } else if (snapshot.data ==
                          SearchStatus.AFTERSEARCHWITHRESULT) {
                        if (isPullDown)
                          _refreshController.refreshCompleted();
                        else
                          _refreshController.loadComplete();

                        return SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: WaterDropMaterialHeader(
                            color: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          //defaultTargetPlatform == TargetPlatform.iOS?WaterDropHeader():WaterDropMaterialHeader(),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          child: snapshot.data == null
                              ? ListView(
                                  children: <Widget>[Container()],
                                )
                              : ListView.builder(
                                  itemCount: (snapshot.data == null ||
                                          searchBloc.resultList == null ||
                                          searchBloc.resultList.length < 1)
                                      ? 0
                                      : searchBloc.resultList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildVideoItem(
                                        context, searchBloc.resultList[index]);
                                  }),
                        );
                      } else if (snapshot.data == SearchStatus.SEARCHING) {
                        return Center(child: RefreshProgressIndicator());
                      } else {
                        LogUtil.e(
                            "snapshot.data != SearchStatus.AFTERSEARCHNORESULT",
                            tag: "***** BrandSearchPage *****");
                        return EmptyView(
                          error: 'sorry we could not find any result',
                          backgroundColor: Colors.transparent,
                        );
                      }
                    }))));
  }

  Container _buildAppBar(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.red,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 6.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Icon(
                      Icons.search,
                      color: Color(0xffadadad),
                      size: 26,
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: TextField(
                    key: _searchKey,
                    autofocus: true,
                    onSubmitted: ((text) {
                      if (text.trim().length != 0) {
                        searchBloc.getSearchResult(text.trim());
                      }
                    }),
                    textInputAction: TextInputAction.search,
                    style: new TextStyle(
                        fontSize: 14.0, height: 1.0, color: Colors.black),
                    controller: _textController,
                    autocorrect: false,
                    onChanged: (text) {
                      if (text.trim().length == 0) searchBloc.clearSearchTF();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                      border: InputBorder.none,
                      hintText: 'type a word to search',
                    ),
                  ),
                )),
                SizedBox(
                  width: 5.0,
                ),
                InkWell(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                    onTap: (() =>
                        {searchBloc.clearSearchTF(), _textController.clear()})),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                ),
              ],
            ),
          )),
          InkWell(
              child: Padding(
                padding: EdgeInsets.only(right: 15.0, left: 15.0),
                child: new Text(
                  'Back',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.Med_14_White,
                ),
              ),
              onTap: (() =>
                  {searchBloc.clearSearchTF(), Navigator.pop(context)})),
        ],
      ),
    );
  }

  Widget buildVideoItem(BuildContext context, SearchItems item) {
    var image = Center(
      child: new CachedNetworkImage(
        imageUrl: item.snippet.thumbnails.high.url,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.red,
            ),
        fit: BoxFit.cover,
        fadeInCurve: Curves.easeIn,
        fadeInDuration: Duration(seconds: 1),
        fadeOutCurve: Curves.easeOut,
        fadeOutDuration: Duration(seconds: 1),
      ),
    );

    var title = Positioned(
      left: 15,
      right: 15,
      top: 10,
      bottom: 0,
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(item.snippet.title,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.Med_14_White),
            ),
          ],
        ),
      ),
    );

    var container = Container(
      padding: EdgeInsets.only(
        top: 15.0,
        left: 15.0,
        right: 15.0,
      ),
      height: 300.0,
      child: new Container(
        decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colours.app_main_0c,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(
                  0.0, // horizontal, move right 10
                  5.0, // vertical, move down 10
                ),
              )
            ],
            color: Colors.white,
            borderRadius: new BorderRadius.all(
              Radius.circular(5.0),
            )),
        child: Stack(
          children: <Widget>[image, title],
        ),
      ),
    );

    return new InkWell(
      child: container,
      onTap: () {},
    );
  }

  Widget _buildHistory(BuildContext context, List<String> historyStrings) {
    if (historyStrings == null || historyStrings.length == 0)
      return Container();
    final List<Widget> chips = historyStrings.map<Widget>((String str) {
      return InkWell(
        child: Chip(
          labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          key: ValueKey<String>(str),
          backgroundColor: Colors.white,
          shape:
              StadiumBorder(side: BorderSide(color: Colors.grey, width: 0.5)),
          label: Text(
            str,
            style: TextStyles.Regular_16_666,
          ),
        ),
        onTap: (() => {
              searchBloc.getSearchResult(str),
              _textController.value = new TextEditingValue(text: str)
            }),
      );
    }).toList();

    return Column(
      children: <Widget>[
        new _ChipsTile(
          children: chips,
          bloc: searchBloc,
        ),
      ],
    );
  }
}

class _ChipsTile extends StatelessWidget {
  const _ChipsTile({Key key, this.children, this.bloc}) : super(key: key);

  final List<Widget> children;
  final SearchBloc bloc;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cardChildren = <Widget>[
      Container(
        height: 57,
        padding: EdgeInsets.only(top: 15, left: 7.5, right: 7.5),
        child: Row(
          children: <Widget>[
            Text(
              'Search History:',
              style: TextStyles.Med_16_333,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
                size: 26,
              ),
              onTap: () => bloc.clearSearchHistory(),
            ),
          ],
        ),
      )
    ];
    cardChildren.add(Wrap(
        children: children.map((Widget chip) {
      return Padding(
        padding: const EdgeInsets.all(7.5),
        child: chip,
      );
    }).toList()));

    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: cardChildren,
      ),
    );
  }
}
