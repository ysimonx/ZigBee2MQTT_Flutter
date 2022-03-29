import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late SharedPreferences prefs;

  late Zigbee2MQTTManager _manager;
  bool boolIsFirstBuildDone = false;

  void _clickFloatingButton() {
    setState(() {});
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
              _onTapSettings(context);
            },
            child: const Icon(
              Icons.settings,
              size: 26.0,
            ),
          ),
        )
      ]),
      body: _manager.hmapDevices().isNotEmpty
          ? RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemCount: _manager.hmapDevices().length,
                itemBuilder: (BuildContext context, int index) {
                  HashMap x = _manager.hmapDevices();
                  ZigBeeDevice device = x.values.elementAt(index);

                  return Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(10),
                      child: _buildCard(context, device));
                },
              ))
          : const Center(child: Text('No items')),

      floatingActionButton: FloatingActionButton(
        onPressed: _clickFloatingButton,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildCard(BuildContext context, ZigBeeDevice device) {
    /* return Text('${device.name}\n' +
        '${device.description}\n' +
        '${device.exposes.keys.join(", ")}\n');
    */
    String deviceKey = device.adresseIEEE;

    return ListTile(
        title: Text(deviceKey),
        onTap: () {
          print("${device.name}");
          _manager.toggleState(device);
        },
        leading: const Icon(Icons.lightbulb),
        trailing: const Text('trailing'),
        subtitle: Text('${device.name}\n' +
            '${device.description}\n' +
            '${device.exposes.keys.join(", ")}\n'),
        isThreeLine: true);
  }

  void _onTapSettings(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(SETTINGS_ROUTE);

    setState(() {
      _manager.disconnect();
    });
  }

  onAfterBuild(BuildContext context) {
    boolIsFirstBuildDone = true;
    _configureAndConnect();
  }

  void _configureAndConnect() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      String _host = (prefs.getString('host') ?? '172.16.66.100');
      int _port = (prefs.getInt('port') ?? 1883);

      _manager.start(host: _host, port: _port);
    });
  }

  Future<void> _pullRefresh() async {}
}
