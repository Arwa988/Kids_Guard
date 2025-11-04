class lifestyleData {
  String? id;
  String? title;
  String? image;
  String? articleReference;
  String? content;
  String? source;
  String? url;

  lifestyleData({
    this.id,
    this.title,
    this.image,
    this.articleReference,
    this.content,
    this.source,
    this.url,
  });

  lifestyleData copyWith({
    String? id,
    String? title,
    String? image,
    String? articleReference,
    String? content,
    String? source,
    String? url,
  }) => lifestyleData(
    id: id ?? this.id,
    title: title ?? this.title,
    image: image ?? this.image,
    articleReference: articleReference ?? this.articleReference,
    content: content ?? this.content,
    source: source ?? this.source,
    url: url ?? this.url,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["image"] = image;
    map["article_reference"] = articleReference;
    map["content"] = content;
    map["source"] = source;
    map["url"] = url;
    return map;
  }

  lifestyleData.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    image = json["image"];
    articleReference = json["article_reference"];
    content = json["content"];
    source = json["source"];
    url = json["url"];
  }
}

class LifeStyleResponse {
  List<lifestyleData>? dataList;
  String? statusMsg;
  String? message;

  LifeStyleResponse({this.dataList, this.statusMsg, this.message});

  LifeStyleResponse copyWith({
    List<lifestyleData>? dataList,
    String? statusMsg,
    String? message,
  }) => LifeStyleResponse(
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

  LifeStyleResponse.fromJson(dynamic json) {
    if (json is List) {
      // ✅ Case 1: API returns a list directly
      dataList = [];
      json.forEach((v) {
        dataList?.add(lifestyleData.fromJson(v));
      });
      statusMsg = "success";
      message = "Lifestyle articles fetched successfully";
    } else if (json is Map<String, dynamic>) {
      // ✅ Case 2: API returns an object with keys
      statusMsg = json["statusMsg"];
      message = json["message"];
      if (json["data"] != null && json["data"] is List) {
        dataList = [];
        json["data"].forEach((v) {
          dataList?.add(lifestyleData.fromJson(v));
        });
      }
    }
  }
}
