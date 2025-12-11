class AIData {
  String? id;
  String? image;
  String? title;
  String? content;
  String? source;
  String? url;

  AIData({
    this.id,
    this.image,
    this.title,
    this.content,
    this.source,
    this.url,
  });

  AIData copyWith({
    String? id,
    String? image,
    String? title,
    String? content,
    String? source,
    String? url,
  }) =>
      AIData(
        id: id ?? this.id,
        image: image ?? this.image,
        title: title ?? this.title,
        content: content ?? this.content,
        source: source ?? this.source,
        url: url ?? this.url,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["image"] = image;
    map["title"] = title;
    map["content"] = content;
    map["source"] = source;
    map["url"] = url;
    return map;
  }

  AIData.fromJson(dynamic json) {
    id = json["id"]?.toString();
    image = json["image"];
    title = json["title"];
    content = json["content"];
    source = json["source"];
    url = json["url"];
  }
}

class AiResponse {
  List<AIData>? dataList;
  String? statusMsg;
  String? message;

  AiResponse({this.dataList, this.statusMsg, this.message});

  AiResponse copyWith({
    List<AIData>? dataList,
    String? statusMsg,
    String? message,
  }) =>
      AiResponse(
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

  AiResponse.fromJson(dynamic json) {
    if (json != null) {
      if (json is List) {
        // Case 1: API returns a list directly
        dataList = [];
        for (var v in json) {
          dataList?.add(AIData.fromJson(v));
        }
        statusMsg = "success";
        message = "AI data fetched successfully";
      } else if (json is Map<String, dynamic>) {
        // Case 2: API returns a wrapped object
        statusMsg = json["statusMsg"];
        message = json["message"];
        if (json["data"] != null && json["data"] is List) {
          dataList = [];
          for (var v in json["data"]) {
            dataList?.add(AIData.fromJson(v));
          }
        }
      }
    }
  }
}
