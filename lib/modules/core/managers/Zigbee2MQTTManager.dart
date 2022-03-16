import 'MQTTManager.dart';

class Zigbee2MQTTManager extends MQTTManager {
  /* 
 void onConnected() {
    super.onConnected();
  }
 */

  void updateState() {
    notifyListeners();
  }
}
