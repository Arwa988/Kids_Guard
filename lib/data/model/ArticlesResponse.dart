class Data {
  String? id;
  String? image;
  String? title;
  String? articleReference;
  String? content;
  String? source;
  String? url;

  Data({
    this.id,
    this.image,
    this.title,
    this.articleReference,
    this.content,
    this.source,
    this.url,
  });

  Data copyWith({
    String? id,
    String? image,
    String? title,
    String? articleReference,
    String? content,
    String? source,
    String? url,
  }) =>
      Data(
        id: id ?? this.id,
        image: image ?? this.image,
        title: title ?? this.title,
        articleReference: articleReference ?? this.articleReference,
        content: content ?? this.content,
        source: source ?? this.source,
        url: url ?? this.url,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["image"] = image;
    map["title"] = title;
    map["article_reference"] = articleReference;
    map["content"] = content;
    map["source"] = source;
    map["url"] = url;
    return map;
  }

  Data.fromJson(dynamic json) {
    id = json["id"]?.toString();
    image = json["image"];
    title = json["title"];
    articleReference = json["article_reference"];
    content = json["content"];
    source = json["source"];
    url = json["url"];
  }
}

class ArticlesResponse {
  List<Data>? dataList;
  String? statusMsg;
  String? message;

  ArticlesResponse({this.dataList, this.statusMsg, this.message});

  ArticlesResponse copyWith({
    List<Data>? dataList,
    String? statusMsg,
    String? message,
  }) =>
      ArticlesResponse(
        dataList: dataList ?? this.dataList,
        statusMsg: statusMsg ?? this.statusMsg,
        message: message ?? this.message,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    if (statusMsg != null) map["statusMsg"] = statusMsg;
    if (message != null) map["message"] = message;
    return map;
  }

  ArticlesResponse.fromJson(dynamic json) {
    if (json is List) {
      // ✅ Case 1: API returns a list directly
      dataList = [];
      for (var v in json) {
        dataList?.add(Data.fromJson(v));
      }
      statusMsg = "success";
      message = "Articles fetched successfully";
    } else if (json is Map<String, dynamic>) {
      // ✅ Case 2: API returns an object with keys
      statusMsg = json["statusMsg"];
      message = json["message"];
      final dataKey = json["data"];
      if (dataKey != null && dataKey is List) {
        dataList = [];
        for (var v in dataKey) {
          dataList?.add(Data.fromJson(v));
        }
      }
    }
  }
}
