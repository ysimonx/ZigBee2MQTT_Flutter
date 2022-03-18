import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zigbee2mqtt_flutter/modules/core/models/IOTDevice.dart';
import '../../modules/core/models/MQTTAppState.dart';
import '../core/managers/Zigbee2MQTTManager.dart';
import '../helpers/screen_route.dart';

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

  late Zigbee2MQTTManager _manager;
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
    _manager = Provider.of<Zigbee2MQTTManager>(context);

    if (boolIsFirstBuildDone) {
      var x = _manager.currentState.getAppConnectionState;

      if (x == MQTTAppConnectionState.disconnected) {
        _configureAndConnect();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Devices List'), actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SETTINGS_ROUTE);
            },
            child: const Icon(
              Icons.settings,
              size: 26.0,
            ),
          ),
        )
      ]),
      body: _manager.hmapDevices().isNotEmpty
          ? ListView.builder(
              itemCount: _manager.hmapDevices().length,
              itemBuilder: (BuildContext context, int index) {
                HashMap x = _manager.hmapDevices();
                String device_key = x.keys.elementAt(index);
                ZigBeeDevice device = x.values.elementAt(index);
                return ListTile(
                  title: Text('Device :  ${device_key}'),
                );
              },
            )
          : const Center(child: Text('No items')),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  onAfterBuild(BuildContext context) {
    boolIsFirstBuildDone = true;
    _configureAndConnect();
  }

  void _configureAndConnect() {
    _manager.start(host: widget.mqttHost, port: widget.mqttPort);
  }
}
