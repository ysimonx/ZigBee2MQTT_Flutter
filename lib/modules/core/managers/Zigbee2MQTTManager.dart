import 'package:zigbee2mqtt_flutter/modules/core/models/IOTDevice.dart';

import 'MQTTManager.dart';

class Zigbee2MQTTManager extends MQTTManager {
  List<ZigBeeDevice> listDevices = List<ZigBeeDevice>.empty();

  /* 
 void onConnected() {
    super.onConnected();
  }


  void updateState() {
    notifyListeners();
  }
   */
}
