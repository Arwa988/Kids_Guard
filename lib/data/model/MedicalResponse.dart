class MedicalData {
  String? id;
  String? title;
  String? image;
  String? content;
  String? source;
  String? url;

  MedicalData({
    this.id,
    this.title,
    this.image,
    this.content,
    this.source,
    this.url,
  });

  MedicalData copyWith({
    String? id,
    String? title,
    String? image,
    String? content,
    String? source,
    String? url,
  }) => MedicalData(
    id: id ?? this.id,
    title: title ?? this.title,
    image: image ?? this.image,
    content: content ?? this.content,
    source: source ?? this.source,
    url: url ?? this.url,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["image"] = image;
    map["content"] = content;
    map["source"] = source;
    map["url"] = url;
    return map;
  }

  MedicalData.fromJson(dynamic json) {
    id = json["id"]?.toString();
    title = json["title"];
    image = json["image"];
    content = json["content"];
    source = json["source"];
    url = json["url"];
  }
}

class MedicalResponse {
  List<MedicalData>? medicalDataList;
  String? statusMsg;
  String? message;

  MedicalResponse({this.medicalDataList, this.statusMsg, this.message});

  MedicalResponse copyWith({
    List<MedicalData>? medicalDataList,
    String? statusMsg,
    String? message,
  }) => MedicalResponse(
    medicalDataList: medicalDataList ?? this.medicalDataList,
    statusMsg: statusMsg ?? this.statusMsg,
    message: message ?? this.message,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (medicalDataList != null) {
      map["data"] = medicalDataList?.map((v) => v.toJson()).toList();
    }
    if (statusMsg != null) map["statusMsg"] = statusMsg;
    if (message != null) map["message"] = message;
    return map;
  }

  MedicalResponse.fromJson(dynamic json) {
    if (json is List) {
      // ✅ Case 1: API returns a List directly
      medicalDataList = [];
      for (var v in json) {
        medicalDataList?.add(MedicalData.fromJson(v));
      }
      statusMsg = "success";
      message = "Medical data fetched successfully";
    } else if (json is Map<String, dynamic>) {
      // ✅ Case 2: API returns an object with keys
      statusMsg = json["statusMsg"]?.toString();
      message = json["message"]?.toString();

      // 👇 Support for "data" or "MedicalData" or custom key
      final dataKey =
          json["data"] ??
          json["MedicalData"] ??
          json["Medical_Guidelines_CaseStudies"];
      if (dataKey != null && dataKey is List) {
        medicalDataList = [];
        for (var v in dataKey) {
          medicalDataList?.add(MedicalData.fromJson(v));
        }
      }
    }
  }
}
