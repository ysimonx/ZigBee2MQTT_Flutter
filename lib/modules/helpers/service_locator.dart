import 'package:get_it/get_it.dart' show GetIt;
import '../core/managers/Zigbee2MQTTManager.dart';

GetIt service_locator = GetIt.instance;

void setupLocator() {
  service_locator
      .registerLazySingleton<Zigbee2MQTTManager>(() => Zigbee2MQTTManager());
}
