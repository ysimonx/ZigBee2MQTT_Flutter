import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:zigbee2mqtt_flutter/modules/core/models/IOTDevice.dart';

import '../models/MQTTAppState.dart';
import 'MQTTManager.dart';

class Zigbee2MQTTManager extends MQTTManager {
  HashMap _hmapDevices = HashMap<String, ZigBeeDevice>();

  final bool _autoReconnect = true;

  HashMap hmapDevices() => _hmapDevices;

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
      var definition = device["definition"];
      var description = (definition == null) ? "" : definition['description'];
      List<dynamic> exposes = (definition == null) ? [] : definition['exposes'];

      _hmapDevices.putIfAbsent(
          device["ieee_address"],
          () => ZigBeeDevice(
              adresseIEEE: device["ieee_address"],
              name: device["friendly_name"],
              description: description,
              exposes: exposes));
    }

    _hmapDevices.forEach((k, v) {
      print('{ key: $k }');
    });

    notifyListeners();
  }

  @override
  void onDisconnected() {
    super.onDisconnected();
    _hmapDevices = HashMap<String, ZigBeeDevice>();
    notifyListeners();
  }

  @override
  void onConnectionError(Exception e) {
    super.onConnectionError(e);
    notifyListeners();
  }

  void start({required String host, required int port}) {
    var x = currentState.getAppConnectionState;

    if (x == MQTTAppConnectionState.connected) {
      return;
    }

    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    initializeMQTTClient(host: host, port: port, identifier: osPrefix);
    connect();
  }

  void toggleState(ZigBeeDevice device) {
    publish("zigbee2mqtt/${device.adresseIEEE}/set",
        '{"state":"TOGGLE","remember_state":true}');
  }
}
