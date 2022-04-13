import 'package:flutter/material.dart';
import 'package:zigbee2mqtt_flutter/modules/core/models/IOTDevice.dart';

class ExposeSlider extends StatefulWidget {
  final ZigBeeDevice device;

  ExposeSlider({Key? key, required this.device}) : super(key: key);

  @override
  ExposeSliderState createState() => ExposeSliderState();
}

class ExposeSliderState extends State<ExposeSlider> {
  double _currentSliderValue = 20;

  double _min = 0.0;
  double _max = 150.0;

  @override
  initState() {
    super.initState();
    if (widget.device.exposes.keys.contains("brightness")) {
      var expose = widget.device.exposes["brightness"];
      var type = expose["type"];
      if (type == "numeric") {
        _min = expose["value_min"].toDouble();
        _max = expose["value_max"].toDouble();
      }
      print(expose.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: _min,
      max: _max,
      divisions: 5,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
