import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfProvider with ChangeNotifier {
  String _appLanguage = 'en';

  AppConfProvider() {
  
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('language_code');
      print('📁 SharedPreferences keys: ${prefs.getKeys()}');
      if (savedLanguage != null) {
        _appLanguage = savedLanguage;
        print('✅ تم تحميل اللغة المحفوظة: $_appLanguage');
      } else {
        print(
          '⚠️ لم يتم العثور على لغة محفوظة، استخدام الافتراضي: $_appLanguage',
        );
      }
    } catch (e) {
      print('❌ خطأ في تحميل اللغة: $e');
    }
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
      print('💾 تم حفظ اللغة في SharedPreferences: $languageCode');
      _appLanguage = languageCode;
      print('🔄 تحديث اللغة في Provider: $_appLanguage');
      notifyListeners();
    } catch (e) {
      print('❌ خطأ في حفظ اللغة: $e');
    }
  }

  String get appLanguage => _appLanguage;
}
