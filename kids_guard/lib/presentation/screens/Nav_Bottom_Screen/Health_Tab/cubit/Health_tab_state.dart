import 'package:kids_guard/data/model/ArticlesResponse.dart';
import 'package:kids_guard/data/model/EmergencyResponse.dart';
import 'package:kids_guard/data/model/LifeStyleResponse.dart';

abstract class HealthTabState {}

class HealthTabIntialState extends HealthTabState {}

class HealthTabLoadingState extends HealthTabState {}

class HealthTabErrorState extends HealthTabState {
  String error;
  HealthTabErrorState({required this.error});
}

class HealthTabSucessState extends HealthTabState {
  ArticlesResponse response;

  HealthTabSucessState({required this.response});
}

class LifeStyleLoadingState extends HealthTabState {}

class LifeStyleErrorState extends HealthTabState {
  String error;
  LifeStyleErrorState({required this.error});
}

class LifeStyleSucessState extends HealthTabState {
  LifeStyleResponse response;

  LifeStyleSucessState({required this.response});
}

class EmergencyLoadingState extends HealthTabState {}

class EmergencyErrortate extends HealthTabState {
  String error;
  EmergencyErrortate({required this.error});
}

class EmergencySucesstate extends HealthTabState {
  EmergencyResponse response;

  EmergencySucesstate({required this.response});
}

class CategoryChangedState extends HealthTabState {} // ✅ Added this
