import 'package:json_annotation/json_annotation.dart';
part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse{

  String kind;
  String etag;
  String nextPageToken;
  String regionCode;
  PageInfo pageInfo;
  List<SearchItems> items;

  SearchResponse({
    this.kind,this.etag,this.nextPageToken,this.regionCode,this.pageInfo,this.items
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);
}

@JsonSerializable()
class PageInfo{

  int totalResults;
  int resultsPerPage;

  PageInfo({
    this.totalResults,this.resultsPerPage
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);
}


@JsonSerializable()
class SearchItems{

  String kind;
  String etag;
  IdModel id;
  SnippetModel snippet;

  SearchItems({
    this.etag,this.id,this.snippet
  });

  factory SearchItems.fromJson(Map<String, dynamic> json) => _$SearchItemsFromJson(json);

}

@JsonSerializable()
class IdModel{

  String kind;
  String videoId;

  IdModel({
    this.kind,this.videoId

  });

  factory IdModel.fromJson(Map<String, dynamic> json) => _$IdModelFromJson(json);

}

@JsonSerializable()
class SnippetModel{

  String publishedAt;
  String channelId;
  String title;
  String description;
  ThumbnailsModels thumbnails;
  String channelTitle;
  String liveBroadcastContent;

  SnippetModel({
    this.publishedAt,this.channelId,this.title,this.description,this.thumbnails,this.channelTitle,this.liveBroadcastContent
  });

  factory SnippetModel.fromJson(Map<String, dynamic> json) => _$SnippetModelFromJson(json);
}

@JsonSerializable()
class ThumbnailsModels{

  ThumbnailsModel defaultM;
  ThumbnailsModel medium;
  ThumbnailsModel high;

  ThumbnailsModels({
    this.defaultM, this.medium, this.high
  });

  factory ThumbnailsModels.fromJson(Map<String, dynamic> json) => _$ThumbnailsModelsFromJson(json);
}


@JsonSerializable()
class ThumbnailsModel{

  String url;
  int width;
  int height;

  ThumbnailsModel({
    this.url,this.width,this.height
  });

  factory ThumbnailsModel.fromJson(Map<String, dynamic> json) => _$ThumbnailsModelFromJson(json);
}