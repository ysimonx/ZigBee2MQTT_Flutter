import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'MQTTManager.dart';

import '../models/Zigbee2MQTTAppState.dart';

class Zigbee2MQTTManager extends ChangeNotifier {
  // Private instance of client
  Zigbee2MQTTAppState _currentState = Zigbee2MQTTAppState();

  MQTTManager _mqttManager = new MQTTManager();
}
