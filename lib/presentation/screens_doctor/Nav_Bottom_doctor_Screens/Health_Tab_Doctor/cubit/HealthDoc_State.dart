import 'package:kids_guard/data/model/AiResponse.dart';
import 'package:kids_guard/data/model/FamilyResponse.dart';
import 'package:kids_guard/data/model/MedicalResponse.dart';

abstract class HealthdocState {}
class HealthdocIntialState extends HealthdocState {
}
class MedicaldocLoadingState extends HealthdocState{}

class MedicaldocErrorState extends HealthdocState {
  String error;
  MedicaldocErrorState({required this.error});
}

class MedicalTabSucessState extends HealthdocState {
  MedicalResponse response;

  MedicalTabSucessState({required this.response});
}

class AILoadingState extends HealthdocState{}

class AIErrorState extends HealthdocState {
  String error;
  AIErrorState({required this.error});
}

class AISucessState extends HealthdocState {
  AiResponse response;

  AISucessState({required this.response});
}
class FamilyLoadingState extends HealthdocState{}

class FamilyErrorState extends HealthdocState {
  String error;
  FamilyErrorState({required this.error});
}

class FamilySucessState extends HealthdocState {
  FamilyResponse response;

  FamilySucessState({required this.response});
}