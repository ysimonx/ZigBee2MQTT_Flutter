import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
  final TextEditingController _hostTextController = TextEditingController();

  @override
  void dispose() {
    _hostTextController.dispose();
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
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(
      TextEditingController controller, String hintText) {
    bool shouldEnable = false;

    return TextField(
        enabled: true,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }
}
