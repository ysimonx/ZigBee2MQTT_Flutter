import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/MQTTAppState.dart';

class MQTTManager extends ChangeNotifier {
  // Private instance of client
  MQTTAppState _currentState = MQTTAppState();
  MqttServerClient? _client;
  late String _identifier;
  String? _host;
  int? _port;

  String _error = "";

  void initializeMQTTClient({
    required String host,
    required int port,
    required String identifier,
  }) {
    // Save the values
    _identifier = identifier;
    _host = host;
    _port = port;
    _client = MqttServerClient(_host!, _identifier);
    _client!.port = port;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;
    _client!.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        //.authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client!.connectionMessage = connMess;
  }

  String? get host => _host;
  int? get port => _port;

  String? get error => _error;

  MQTTAppState get currentState => _currentState;
  // Connect to the host
  void connect() async {
    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client!.connect();
      _error = "";
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      onConnectionError(e);
      // disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
    _currentState
        .setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
    updateState();
  }

  void onUnsubscribed(String? topic) {
    print('EXAMPLE::onUnsubscribed confirmed for topic $topic');
    _currentState.clearText();
    _currentState
        .setAppConnectionState(MQTTAppConnectionState.connectedUnSubscribed);
    updateState();
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.clearText();
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    updateState();
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    updateState();

    print('EXAMPLE::Mosquitto client connected....');

    var u = _client!.updates;
    if (u == null) {
      print('client.updates are null');
    }
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (var i = 0; i < c.length; i++) {
        onReceivedMessage(c[i]);
      }
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  /// process incoming message -> topic + payload
  void onReceivedMessage(MqttReceivedMessage<MqttMessage> m) {
    final MqttPublishMessage recMess = m.payload as MqttPublishMessage;
    final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    _currentState.setReceivedText(pt);

    var topic = m.topic;
    var payload = pt;
    onReceivedTopicMessage(topic, payload);
  }

  /// process incoming topic + payload (will be override when class is extends)
  void onReceivedTopicMessage(String topic, String payload) {
    print(
        'EXAMPLE::Change notification:: topic is <${topic}>, payload is <-- ${payload} -->');
    print('');
    // updateState();
  }

  void onConnectionError(Exception e) {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connectionError);
    updateState();
  }

  // subscribe to a topic
  void subScribeTo(String topic) {
    _client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  /// Unsubscribe from a topic
  void unSubscribe(String topic) {
    _client!.unsubscribe(topic);
  }

  void updateState() {
    // notifyListeners();
  }
}
