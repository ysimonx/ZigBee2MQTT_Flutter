class Expose {
  String? _key;
  String? _value;
  String? _type;

  Expose() {
    _key = "";
    _value = "";
    _type = "";
  }

  String? get key => _key;
  String? get value => _value;
  String? get type => _type;
}

class IOTDevice {
  String? _name;
  String? _description;
  String? _network;

  List<Expose> listExposes = List<Expose>.empty();

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

  ZigBeeDevice({String? adresseIEEE, String? name, String? description})
      : super(name: name, description: description) {
    _adresseIEEE = adresseIEEE;
    _network = "Zigbee";
  }

  String? get adresseIEEE => _adresseIEEE;
}
