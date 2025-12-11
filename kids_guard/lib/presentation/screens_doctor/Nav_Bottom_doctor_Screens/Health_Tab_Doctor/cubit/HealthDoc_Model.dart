import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_guard/data/model/AiResponse.dart';
import 'package:kids_guard/data/model/FamilyResponse.dart';
import 'package:kids_guard/data/model/MedicalResponse.dart';
import 'package:kids_guard/data/services/api_manger.dart';
import 'package:kids_guard/presentation/screens_doctor/Nav_Bottom_doctor_Screens/Health_Tab_Doctor/cubit/HealthDoc_State.dart';

class HealthdocModel extends Cubit<HealthdocState> {
  HealthdocModel() : super(HealthdocIntialState());
  List<MedicalData>? MedicalList;
  List<AIData>? AiList;
  List<FamilyData>? FamilyList;
  void getAllMedical() async {
    try {
      emit(MedicaldocLoadingState());
      await Future.delayed(const Duration(milliseconds: 500)); // 👈 wait 800ms

      var response = await ApiManger.getMedical();
      if (response.statusMsg == "fail") {
        emit(MedicaldocErrorState(error: response.message ?? ""));
      } else {
        MedicalList = response.medicalDataList ?? [];
        emit(MedicalTabSucessState(response: response));
      }
    } catch (e) {
      emit(MedicaldocErrorState(error: e.toString()));
    }
  }

  void getAllAI() async {
    try {
      emit(AILoadingState());
      await Future.delayed(const Duration(milliseconds: 800)); // 👈 wait 800ms

      var response = await ApiManger.getAI();
      if (response.statusMsg == "fail") {
        emit(AIErrorState(error: response.message ?? ""));
      } else {
        AiList = response.dataList ?? [];
        emit(AISucessState(response: response));
      }
    } catch (e) {
      emit(AIErrorState(error: e.toString()));
    }
  }

  void getAllFamily() async {
    try {
      emit(FamilyLoadingState());
      await Future.delayed(const Duration(milliseconds: 1100)); // 👈 wait 800ms

      var response = await ApiManger.getFamily();
      if (response.statusMsg == "fail") {
        emit(FamilyErrorState(error: response.message ?? ""));
      } else {
        FamilyList = response.dataList ?? [];
        emit(FamilySucessState(response: response));
      }
    } catch (e) {
      emit(AIErrorState(error: e.toString()));
    }
  }

  void getMed() async {
    try {
      emit(MedicaldocLoadingState());
      MedicalResponse response = await ApiManger.getMedical();
      // 34an ana 3yza a3rd hga byn3ha fa 3mlna obj mn medresponse kolo
      if (response.medicalDataList != null &&
          response.medicalDataList!.isNotEmpty) {
        emit(MedicalTabSucessState(response: response));
      }
    } catch (e) {
      emit(MedicaldocErrorState(error: e.toString()));
    }
  }

  void getAi() async {
    try {
      emit(AILoadingState());
      AiResponse response = await ApiManger.getAI();
      if (response.dataList != null && response.dataList!.isNotEmpty) {
        emit(AISucessState(response: response));
      }
    } catch (e) {
      emit(AIErrorState(error: e.toString()));
    }
  }
    void getFam() async {
    try {
      emit(FamilyLoadingState());
      FamilyResponse response = await ApiManger.getFamily();
      if (response.dataList != null && response.dataList!.isNotEmpty) {
        emit(FamilySucessState(response: response));
      }
    } catch (e) {
      emit(FamilyErrorState(error: e.toString()));
    }
  }
}
