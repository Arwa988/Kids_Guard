class EmergencyData {
  num? id;
  String? title;
  List<String>? contentList;
    String? source;

  EmergencyData({this.id, this.title, this.contentList});

  // ✅ العناوين العربية الجديدة (حسب الـ JSON المرسل)
  String get titleAr {
    switch (id) {
      case 1:
        return "إذا أُغمي على طفلك (الإسعافات الأولية للإغماء)";
      case 2:
        return "الإنعاش القلبي الرئوي للأطفال: دليل خطوة بخطوة";
      case 3:
        return "توقف القلب المفاجئ عند الأطفال: ماذا تفعل";
      case 4:
        return "الإسعافات الأولية للنوبة القلبية عند الأطفال";
      default:
        return title ?? "";
    }
  }

  // ✅ المحتوى العربي الجديد (قائمة الخطوات كاملة)
  List<String> get contentListAr {
    switch (id) {
      case 1:
        return [
          "1. ابقَ هادئًا وتأكد أن طفلك مستلقٍ على ظهره.",
          "2. ارفع ساقيه حوالي 30 سم (12 بوصة) للمساعدة على وصول الدم إلى الدماغ.",
          "3. فك أي ملابس ضيقة حول الرقبة أو الخصر.",
          "4. افحص التنفس والنبض. إذا كانا طبيعيين، اتركه يستريح حتى يستعيد وعيه تمامًا.",
          "5. بعد الإفاقة، ساعده على الجلوس ببطء وأعطه ماء.",
          "6. إذا استمر الإغماء أكثر من دقيقة أو توقف التنفس، اتصل بالإسعاف فورًا (123 أو 911).",
          "7. إذا تكرر الإغماء، تواصل مع طبيب طفلك.",
        ];
      case 2:
        return [
          "1. تأكد إذا كان الطفل يستجيب عن طريق الربت عليه والمناداة: هل أنت بخير؟",
          "2. إذا لم يستجب، اتصل بالإسعاف فورًا.",
          "3. ضع الطفل مستلقيًا على سطح ثابت.",
          "4. افتح مجرى الهواء بإمالة الرأس للخلف قليلًا ورفع الذقن.",
          "5. افحص التنفس لمدة 10 ثوانٍ. إذا لم يكن هناك تنفس، ابدأ الإنعاش القلبي الرئوي.",
          "6. ضع يدًا واحدة في منتصف الصدر واضغط بقوة وسرعة بعمق حوالي 5 سم بمعدل 100–120 ضغطة في الدقيقة.",
          "7. قم بـ 30 ضغطة على الصدر ثم نفسين إنقاذيين.",
          "8. استمر حتى تصل المساعدة أو يبدأ الطفل في التنفس.",
        ];
      case 3:
        return [
          "1. إذا انهار الطفل فجأة ولم يكن يتنفس، تصرف بسرعة.",
          "2. اتصل بالإسعاف فورًا (123 أو 911).",
          "3. ابدأ الإنعاش القلبي الرئوي فورًا بـ 30 ضغطة على الصدر ونفسين.",
          "4. اضغط بقوة وسرعة في منتصف الصدر.",
          "5. إذا كان جهاز الصدمات الكهربائية (AED) متوفرًا، شغّله واتبع التعليمات الصوتية.",
          "6. استمر في الإنعاش حتى تصل المساعدة الطبية أو يبدأ الطفل في التنفس.",
        ];
      case 4:
        return [
          "1. ابقَ هادئًا واتصل بالإسعاف فورًا (123 أو 911).",
          "2. ساعد طفلك على الاستلقاء والراحة في وضع مريح.",
          "3. فك أي ملابس ضيقة لتسهيل التنفس.",
          "4. إذا توقف التنفس، ابدأ الإنعاش القلبي الرئوي فورًا (30 ضغطة، نفسين).",
          "5. استخدم جهاز الصدمات الكهربائية (AED) إذا كان متوفرًا واتبع التعليمات الصوتية.",
          "6. لا تعطِ طعامًا أو شرابًا حتى تصل المساعدة الطبية.",
        ];
      default:
        return contentList ?? [];
    }
  }
  String get sourceAr {
    switch (id) {
      case 1: return "ميدلاين بلس - إسعافات أولية";
      case 2: return "جمعية القلب الأمريكية (AHA)";
      case 3: return "الصليب الأحمر الدولي";
      case 4: return "مايو كلينك الطبي";
      default: return source ?? "  ";
    }
  }

  EmergencyData.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    contentList = json["content"] != null ? json["content"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["content"] = contentList;
    return map;
  }
}

class EmergencyResponse {
  List<EmergencyData>? dataList;
  String? statusMsg;
  String? message;

  EmergencyResponse({this.dataList, this.statusMsg, this.message});

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
