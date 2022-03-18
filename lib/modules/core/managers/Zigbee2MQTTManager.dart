import 'dart:collection';
import 'dart:convert';

import 'package:zigbee2mqtt_flutter/modules/core/models/IOTDevice.dart';

import 'MQTTManager.dart';

class Zigbee2MQTTManager extends MQTTManager {
  HashMap _hmapDevices = HashMap<String, ZigBeeDevice>();

  @override
  void onConnected() {
    super.onConnected();
    subScribeTo("zigbee2mqtt/bridge/devices");
    subScribeTo("zigbee2mqtt/+");
  }

  @override
  void onReceivedTopicMessage(String topic, String payload) {
    super.onReceivedTopicMessage(topic, payload);
    if (topic == "zigbee2mqtt/bridge/devices") {
      refreshListDevices(payload);
    }
  }

  @override
  void updateState() {
    super.updateState();
  }

  void refreshListDevices(String payload) {
    // Notice how you have to call body from the response if you are using http to retrieve json
    final jsonPayload = json.decode(payload);

    var x = List.from(jsonPayload);
    _hmapDevices = HashMap<String, ZigBeeDevice>();

    for (var i = 0; i < x.length; i++) {
      var device = x[i];

      _hmapDevices.putIfAbsent(
          device["ieee_address"],
          () => ZigBeeDevice(
              adresseIEEE: device["ieee_address"],
              name: device["friendly_name"],
              description: device["description"]));
    }

    _hmapDevices.forEach((k, v) {
      print('{ key: $k }');
    });

    notifyListeners();
  }
}
