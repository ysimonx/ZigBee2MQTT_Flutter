import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/core/managers/MQTTManager.dart';
import 'modules/helpers/service_locator.dart';
import 'modules/screens/myHomePage.dart';

const mqttHost = "10.8.0.4";

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTManager>(
        create: (context) => service_locator<MQTTManager>(),
        child: MaterialApp(
            title: 'Flutter ZigBee2MQTT Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (BuildContext context) => const MyHomePage(
                  mqttHost: mqttHost,
                  title: 'Flutter Demo ZigBee2MQTT 1st Page'),
            }));
  }
}
