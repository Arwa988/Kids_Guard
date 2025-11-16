class EmergencyData {
  num? id;
  String? title;
  List<String>? contentList;

  EmergencyData({this.id, this.title, this.contentList});

  EmergencyData copyWith({
    num? id,
    String? title,
    List<String>? contentList,
  }) =>
      EmergencyData(
        id: id ?? this.id,
        title: title ?? this.title,
        contentList: contentList ?? this.contentList,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["content"] = contentList;
    return map;
  }

  EmergencyData.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    contentList = json["content"] != null ? json["content"].cast<String>() : [];
  }
}

class EmergencyResponse {
  List<EmergencyData>? dataList;
  String? statusMsg; // e.g. "success" or "fail"
  String? message;   // descriptive message

  EmergencyResponse({this.dataList, this.statusMsg, this.message});

  EmergencyResponse copyWith({
    List<EmergencyData>? dataList,
    String? statusMsg,
    String? message,
  }) =>
      EmergencyResponse(
        dataList: dataList ?? this.dataList,
        statusMsg: statusMsg ?? this.statusMsg,
        message: message ?? this.message,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["statusMsg"] = statusMsg;
    map["message"] = message;
    if (dataList != null) {
      map["data"] = dataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  EmergencyResponse.fromJson(dynamic json) {
    if (json == null) return;
    statusMsg = json["statusMsg"];
    message = json["message"];
    if (json["data"] != null) {
      dataList = [];
      json["data"].forEach((v) {
        dataList?.add(EmergencyData.fromJson(v));
      });
    }
  }
}
