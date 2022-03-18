import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/core/managers/Zigbee2MQTTManager.dart';
import 'modules/helpers/screen_route.dart';
import 'modules/helpers/service_locator.dart';
import 'modules/screens/myHomePage.dart';
import 'modules/screens/settings_screen.dart';

const mqttHost = "192.168.85.3";
const mqttPort = 1883;

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Zigbee2MQTTManager>(
        create: (context) => service_locator<Zigbee2MQTTManager>(),
        child: MaterialApp(
            title: 'ZigBee2MQTT Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              HOMEPAGE_ROUTE: (BuildContext context) => const MyHomePage(
                  mqttHost: mqttHost,
                  mqttPort: mqttPort,
                  title: 'ZigBee2MQTT Demo 1st Page'),
              SETTINGS_ROUTE: (BuildContext context) => const SettingsScreen()
            }));
  }
}
