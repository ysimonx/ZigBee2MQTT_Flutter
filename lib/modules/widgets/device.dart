import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/managers/Zigbee2MQTTManager.dart';
import '../core/models/IOTDevice.dart';

class Device extends StatelessWidget {
  late ZigBeeDevice _zigBeeDevice;
  late Zigbee2MQTTManager _manager;

  Device({Key? key, required zigBeeDevice})
      : _zigBeeDevice = zigBeeDevice,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<Zigbee2MQTTManager>(context);
    return _buildConnectionStateText(_manager, _zigBeeDevice);
  }

  Widget _buildConnectionStateText(_manager, ZigBeeDevice device) {
    String deviceKey = device.adresseIEEE;

    List<Widget> l = [];
    l.add(Text('${device.name}\n' +
        '${device.description}\n' +
        '${device.exposes.keys.join(", ")}\n'));

    if (device.exposes.keys.contains("state")) {
      List<Widget> listWidgetStates = [];

      HashMap<String, dynamic> valuesStates = HashMap<String, dynamic>();

      var expose = device.exposes["state"];
      if (expose.keys.contains("type")) {
        if (expose["type"] == "enum") {
          if (expose.keys.contains("values")) {
            for (var i = 0; i < expose["values"].length; i++) {
              String s = expose["values"][i];
              valuesStates.addAll({s: s});
            }
          }
        }
      }
      if (expose["type"] == "binary") {
        valuesStates.addAll({"ON": expose["value_on"]});
        valuesStates.addAll({"OFF": expose["value_off"]});

        var u = expose["value_toggle"];
        if (u != null) {
          valuesStates.addAll({"TOGGLE": expose["value_toggle"]});
        }
      }

      valuesStates.forEach((key, value) {
        listWidgetStates.add(ElevatedButton(
            onPressed: () {
              print("${device.name}");
              _manager.setExpose(device, "state", value);
              print(value);

              // _manager.setExposeState(device, value);
            },
            child: Text(key.toString())));
        listWidgetStates.add(const SizedBox(width: 10));
      });

      l.add(Row(children: listWidgetStates));
    }

    return ListTile(
        title: Text(deviceKey),
        //onTap: () {
        //  print("${device.name}");
        //  _manager.toggleState(device);
        //},
        leading: const Icon(Icons.lightbulb),
        trailing: const Text('trailing'),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: l),
        isThreeLine: true);
  }
}
