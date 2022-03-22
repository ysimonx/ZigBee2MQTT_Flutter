import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/managers/MQTTManager.dart';
import '../core/models/MQTTAppState.dart';
import '../helpers/status_info_message_utils.dart';
import '../widgets/status_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _host = "";
  int _port = 0;

  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _portTextController = TextEditingController();

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadPreferences().whenComplete(() {
      setState(() {
        _hostTextController.text = _host;
        String s = _port.toString();

        _portTextController.text = s;
      });
    });
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _portTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context) as PreferredSizeWidget?,
        body: _buildColumn());
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: Colors.greenAccent,
    );
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildEditableColumn(),
      ],
    );
  }

  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, 'Enter broker address'),
          const SizedBox(height: 10),
          _buildTextFieldWith(_portTextController, 'Enter broker port'),
          const SizedBox(height: 10),
          RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                String host = _hostTextController.text;
                String port = _portTextController.text;
                if (host != '' && port != '') {
                  print('Successfull');
                  prefs.setString('host', host);
                  prefs.setInt('port', int.parse(port));
                  Navigator.pop(context, 'restart');
                }
              },
              child: const Text("update")),
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(
      TextEditingController controller, String hintText) {
    return TextField(
        enabled: true,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _host = (prefs.getString('host') ?? 'host');
      _port = (prefs.getInt('port') ?? 0);
    });
  }
}
