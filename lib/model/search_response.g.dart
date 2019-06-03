// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) {
  return SearchResponse(
      kind: json['kind'] as String,
      etag: json['etag'] as String,
      nextPageToken: json['nextPageToken'] as String,
      regionCode: json['regionCode'] as String,
      pageInfo: json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      items: (json['items'] as List)
          ?.map((e) => e == null
              ? null
              : SearchItems.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'etag': instance.etag,
      'nextPageToken': instance.nextPageToken,
      'regionCode': instance.regionCode,
      'pageInfo': instance.pageInfo,
      'items': instance.items
    };

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) {
  return PageInfo(
      totalResults: json['totalResults'] as int,
      resultsPerPage: json['resultsPerPage'] as int);
}

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
      'totalResults': instance.totalResults,
      'resultsPerPage': instance.resultsPerPage
    };

SearchItems _$SearchItemsFromJson(Map<String, dynamic> json) {
  return SearchItems(
      etag: json['etag'] as String,
      id: json['id'] == null
          ? null
          : IdModel.fromJson(json['id'] as Map<String, dynamic>),
      snippet: json['snippet'] == null
          ? null
          : SnippetModel.fromJson(json['snippet'] as Map<String, dynamic>))
    ..kind = json['kind'] as String;
}

Map<String, dynamic> _$SearchItemsToJson(SearchItems instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'etag': instance.etag,
      'id': instance.id,
      'snippet': instance.snippet
    };

IdModel _$IdModelFromJson(Map<String, dynamic> json) {
  return IdModel(
      kind: json['kind'] as String, videoId: json['videoId'] as String);
}

Map<String, dynamic> _$IdModelToJson(IdModel instance) =>
    <String, dynamic>{'kind': instance.kind, 'videoId': instance.videoId};

SnippetModel _$SnippetModelFromJson(Map<String, dynamic> json) {
  return SnippetModel(
      publishedAt: json['publishedAt'] as String,
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnails: json['thumbnails'] == null
          ? null
          : ThumbnailsModels.fromJson(
              json['thumbnails'] as Map<String, dynamic>),
      channelTitle: json['channelTitle'] as String,
      liveBroadcastContent: json['liveBroadcastContent'] as String);
}

Map<String, dynamic> _$SnippetModelToJson(SnippetModel instance) =>
    <String, dynamic>{
      'publishedAt': instance.publishedAt,
      'channelId': instance.channelId,
      'title': instance.title,
      'description': instance.description,
      'thumbnails': instance.thumbnails,
      'channelTitle': instance.channelTitle,
      'liveBroadcastContent': instance.liveBroadcastContent
    };

ThumbnailsModels _$ThumbnailsModelsFromJson(Map<String, dynamic> json) {
  return ThumbnailsModels(
      defaultM: json['default'] == null
          ? null
          : ThumbnailsModel.fromJson(json['default'] as Map<String, dynamic>),
      medium: json['medium'] == null
          ? null
          : ThumbnailsModel.fromJson(json['medium'] as Map<String, dynamic>),
      high: json['high'] == null
          ? null
          : ThumbnailsModel.fromJson(json['high'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ThumbnailsModelsToJson(ThumbnailsModels instance) =>
    <String, dynamic>{
      'default': instance.defaultM,
      'medium': instance.medium,
      'high': instance.high
    };

ThumbnailsModel _$ThumbnailsModelFromJson(Map<String, dynamic> json) {
  return ThumbnailsModel(
      url: json['url'] as String,
      width: json['width'] as int,
      height: json['height'] as int);
}

Map<String, dynamic> _$ThumbnailsModelToJson(ThumbnailsModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height
    };
