import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/core/models/MQTTAppState.dart';
import '../../modules/helpers/status_info_message_utils.dart';
import '../core/managers/MQTTManager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.mqttHost,
      required this.mqttPort})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String mqttHost;
  final int mqttPort;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late MQTTManager _manager;
  bool boolIsFirstBuildDone = false;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  initState() {
    super.initState();
    boolIsFirstBuildDone = false;
    WidgetsBinding.instance?.addPostFrameCallback((_) => onAfterBuild(context));
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);

    if (boolIsFirstBuildDone) {
      var x = _manager.currentState.getAppConnectionState;

      if (x == MQTTAppConnectionState.disconnected) {
        _configureAndConnect();
      }

      if (x == MQTTAppConnectionState.connected) {
        _subscribeTopics();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              prepareStateMessageFrom(
                  _manager.currentState.getAppConnectionState),
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _configureAndConnect() {
    var x = _manager.currentState.getAppConnectionState;

    if (x == MQTTAppConnectionState.connected) {
      return;
    }

    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    _manager.initializeMQTTClient(
        host: widget.mqttHost, port: widget.mqttPort, identifier: osPrefix);
    _manager.connect();
  }

  void _subscribeTopics() {
    _manager.subScribeTo("zigbee2mqtt/bridge/devices");
    _manager.subScribeTo("zigbee2mqtt/+");
  }

  void _disconnect() {
    _manager.disconnect();
  }

  onAfterBuild(BuildContext context) {
    boolIsFirstBuildDone = true;
    _configureAndConnect();
  }
}
