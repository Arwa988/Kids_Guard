import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';

import 'package:kids_guard/data/services/api_manger.dart';
import 'package:kids_guard/presentation/screens/Nav_Bottom_Screen/Health_Tab/cubit/Health_tab_state.dart';

class HealthTabModel extends Cubit<HealthTabState> {
  HealthTabModel() : super(HealthTabIntialState());
  // list mn data el api
  List<EmergencyData>? emergencyList;
  List<Data>? articlesList;
  List<lifestyleData>? lifestyleList;

  void getAllEmergency() async {
    try {
      emit(EmergencyLoadingState());
      await Future.delayed(const Duration(milliseconds: 200)); // 👈 wait 800ms
      var response = await ApiManger.getEmergency();
      if (response.statusMsg == "fail") {
        emit(EmergencyErrortate(error: response.message ?? ""));
      } else {
        emergencyList = response.dataList ?? [];
        emit(EmergencySucesstate(response: response));
      }
    } catch (e) {
      emit(EmergencyErrortate(error: e.toString()));
    }
  }

  void getAllArticles() async {
    //emit loading state
    try {
      emit(HealthTabLoadingState());
      // call data from api
      await Future.delayed(const Duration(milliseconds: 500)); // 👈 wait 800ms
      var response = await ApiManger.getArticles();
      // if condition emit error message
      if (response.statusMsg == "fail") {
        // response statusMsg dy byt2olk anta sucess wala la
        emit(HealthTabErrorState(error: response.message ?? ''));
        // message ely maktob fyha error
      }
      //emit sucess
      else {
        articlesList = response.dataList ?? [];
        emit(HealthTabSucessState(response: response));
      }
    } catch (e) {
      emit(HealthTabErrorState(error: e.toString()));
    }
  }

  void getAllLifeStyle() async {
    try {
      emit(LifeStyleLoadingState());
      await Future.delayed(const Duration(milliseconds: 800)); // 👈 wait 800ms
      var response = await ApiManger.getLifeStyle();
      if (response.statusMsg == "fail") {
        emit(LifeStyleErrorState(error: response.message ?? ""));
      } else {
        lifestyleList = response.dataList ?? [];
        emit(LifeStyleSucessState(response: response));
      }
    } catch (e) {
      emit(LifeStyleErrorState(error: e.toString()));
    }
  }

  void getArticles() async {
    try {
      emit(HealthTabLoadingState());

      // Fetch data from API or any data service
      final ArticlesResponse response = await ApiManger.getArticles();

      // If the response has data
      if (response.dataList != null && response.dataList!.isNotEmpty) {
        emit(HealthTabSucessState(response: response));
      } else {
        emit(HealthTabErrorState(error: "No articles available"));
      }
    } catch (e) {
      emit(HealthTabErrorState(error: e.toString()));
    }
  }
    void getEmergency() async {
    try {
      emit(EmergencyLoadingState());

      // Fetch data from API or any data service
      final EmergencyResponse response = await ApiManger.getEmergency();

      // If the response has data
      if (response.dataList != null && response.dataList!.isNotEmpty) {
        emit(EmergencySucesstate(response: response));
      } else {
        emit(EmergencyErrortate(error: "No articles available"));
      }
    } catch (e) {
      emit(EmergencyErrortate(error: e.toString()));
    }
  }

  void getStyle() async {
    try {
      emit(LifeStyleLoadingState());
      LifeStyleResponse response = await ApiManger.getLifeStyle();
      if (response.dataList != null && response.dataList!.isNotEmpty) {
        emit(LifeStyleSucessState(response: response));
      }
    } catch (e) {
      emit(HealthTabErrorState(error: e.toString()));
    }
  }
}
