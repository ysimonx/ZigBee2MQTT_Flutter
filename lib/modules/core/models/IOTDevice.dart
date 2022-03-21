import 'dart:collection';

import 'dart:ffi';

class IOTDevice {
  String? _name;
  String? _description;
  String? _network;

  IOTDevice({String? name, String? description}) {
    _name = name;
    _network = "IOTDevice";
    _description = description;
  }

  String? get network => _network;

  String? get name => _name;
  String? get description => _description;
}

class ZigBeeDevice extends IOTDevice {
  String? _network;
  String? _adresseIEEE;
  List<dynamic> _listExposes = List<dynamic>.empty();

  ZigBeeDevice(
      {String? adresseIEEE,
      String? name,
      String? description,
      List<dynamic>? exposes})
      : super(name: name, description: description) {
    _adresseIEEE = adresseIEEE;
    _network = "Zigbee";
    _listExposes = exposes!;
  }

  String? get adresseIEEE => _adresseIEEE;
  // List? get exposes => _exposes;
  List<dynamic> exposes() => _listExposes;

  List<String> getDeviceTypes() {
    var result = getDeviceType(_listExposes);
    return result;
  }

  List<String> getDeviceType(var param) {
    Map<String, dynamic> expose = Map<String, dynamic>();

    var arr = List<String>.empty(growable: true);

    if (param is Map) {
      expose = Map<String, dynamic>.from(param);
      if (expose.containsKey("features")) {
        var arr_child = getDeviceType(expose["features"]);
        arr.addAll(arr_child);
      }

      if (expose.containsKey("name")) {
        arr.add(expose["name"]);
      }
    }

    if (param is List) {
      for (int i = 0; i < param.length; i++) {
        var arr_child = getDeviceType(param[i]);
        arr.addAll(arr_child);
      }
    }

    return arr;
  }
}
