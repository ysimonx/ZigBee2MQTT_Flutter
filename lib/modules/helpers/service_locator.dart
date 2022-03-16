import 'package:get_it/get_it.dart';
import '../core/managers/MQTTManager.dart';

GetIt service_locator = GetIt.instance;

void setupLocator() {
  service_locator.registerLazySingleton<MQTTManager>(() => MQTTManager());
}
