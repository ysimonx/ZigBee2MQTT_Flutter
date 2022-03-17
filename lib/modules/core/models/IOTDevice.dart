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

  IOTDevice() {
    _network = "IOTDevice";
    _name = "";
    _description = "";
  }
  String? get network => _network;

  String? get name => _name;
  String? get description => _description;
}

class ZigBeeDevice extends IOTDevice {
  String? _network;
  String? _adresseIEEE;

  ZigBeeDevice() : super() {
    _network = "Zigbee";
    _adresseIEEE = "";
  }

  String? get adresseIEEE => _adresseIEEE;
}
