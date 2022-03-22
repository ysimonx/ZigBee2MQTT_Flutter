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
  HashMap<String, dynamic> _exposes = HashMap<String, dynamic>();

  ZigBeeDevice(
      {String? adresseIEEE,
      String? name,
      String? description,
      List<dynamic>? exposes})
      : super(name: name, description: description) {
    _adresseIEEE = adresseIEEE;
    _network = "Zigbee";
    _exposes = getDeviceType(exposes);
  }

  String? get adresseIEEE => _adresseIEEE;
  // List? get exposes => _exposes;

  HashMap<String, dynamic> get exposes => _exposes;

  HashMap<String, dynamic> getDeviceType(var param) {
    var arr = HashMap<String, dynamic>();

    if (param is List) {
      for (int i = 0; i < param.length; i++) {
        var arr_child = getDeviceType(param[i]); // recursif

        var tempHM = HashMap<String, dynamic>();
        for (int i = 0; i < arr_child.keys.length; i++) {
          String key = arr_child.keys.elementAt(i);
          var values = arr_child[key];
          tempHM[key] = values;
        }
        arr.addAll(tempHM);
      }
    }

    if (param is Map) {
      Map<String, dynamic> expose = Map<String, dynamic>.from(param);

      if (expose.containsKey("features")) {
        var arr_child = getDeviceType(expose["features"]); // recursif

        var tempHM = HashMap<String, dynamic>();
        for (int i = 0; i < arr_child.keys.length; i++) {
          String key = arr_child.keys.elementAt(i);
          var values = arr_child[key];
          tempHM[key] = values;
        }
        arr.addAll(tempHM);
      }

      if (expose.containsKey("name")) {
        // c'est la clé de l'expose
        var tempHM = HashMap<String, dynamic>();
        tempHM[expose["name"]] = expose;
        arr.addAll(tempHM);
      }
    }

    return arr;
  }

  void toggle() {}
}
