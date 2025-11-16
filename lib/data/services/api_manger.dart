import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kids_guard/data/model/AiResponse.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/data/model/FamilyResponse.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';
import 'package:kids_guard/data/model/MedicalResponse.dart';
import 'package:kids_guard/data/services/endPoints.dart';

class ApiManger {
  static const String baseUrl = 'https://68f91253deff18f212b88e7a.mockapi.io';
  static const String baseUrlDoc =
      'https://68f964a6ef8b2e621e7bf1b2.mockapi.io';
  static const String baseUrlDocc =
      'https://68fa026def8b2e621e7e6ea5.mockapi.io';

  static Future<ArticlesResponse> getArticles() async {
    Uri url = Uri.parse('$baseUrl${Endpoint.Articles}');
    try {
      var response = await http.get(url);
      var body_string = response.body;
      var json = jsonDecode(body_string);
      return ArticlesResponse.fromJson(json);
    } catch (e) {
      throw Exception("Failed to fetch best sellers: $e");
    }
  }

  static Future<LifeStyleResponse> getLifeStyle() async {
    Uri url = Uri.parse('$baseUrl${Endpoint.LifeStyle}');
    try {
      var response = await http.get(url);
      var body_string = response.body;
      var json = jsonDecode(body_string);
      return LifeStyleResponse.fromJson(json);
    } catch (e) {
      throw Exception("Failed to fetch best sellers: $e");
    }
  }
  // Doctor Api

  static Future<MedicalResponse> getMedical() async {
    Uri url = Uri.parse('$baseUrlDoc/${Endpoint.Medical}');
    try {
      var response = await http.get(url);
      var body_string = response.body;
      var json = jsonDecode(body_string);
      return MedicalResponse.fromJson(json);
    } catch (e) {
      throw Exception("Failed to fetch best sellers: $e");
    }
  }

  static Future<AiResponse> getAI() async {
    Uri url = Uri.parse('$baseUrlDoc/${Endpoint.AI}');
    try {
      var response = await http.get(url);
      var body_string = response.body;
      var json = jsonDecode(body_string);
      return AiResponse.fromJson(json);
    } catch (e) {
      throw Exception("Failed to fetch best sellers: $e");
    }
  }

  static Future<FamilyResponse> getFamily() async {
    Uri url = Uri.parse('$baseUrlDocc/${Endpoint.Family}');
    try {
      var response = await http.get(url);
      var body_string = response.body;
      var json = jsonDecode(body_string);
      return FamilyResponse.fromJson(json);
    } catch (e) {
      throw Exception("Failed to fetch best sellers: $e");
    }
  }

  static Future<EmergencyResponse> getEmergency() async {
    Uri url = Uri.parse('$baseUrlDocc/${Endpoint.Emergency}');
    try {
      var response = await http.get(url);
      var bodyString = response.body;
      var jsonData = jsonDecode(bodyString);

      if (jsonData is List) {
        return EmergencyResponse(
          dataList: jsonData.map((e) => EmergencyData.fromJson(e)).toList(),
          statusMsg: "success",
          message: "Data loaded successfully",
        );
      } else {
        // If backend sends object with "data" key
        return EmergencyResponse.fromJson(jsonData);
      }
    } catch (e) {
      throw Exception("Failed to fetch Emergency data: $e");
    }
  }
}
