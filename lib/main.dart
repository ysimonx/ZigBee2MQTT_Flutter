import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/core/managers/MQTTManager.dart';
import 'modules/helpers/service_locator.dart';
import 'modules/screens/myHomePage.dart';

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
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (BuildContext context) =>
                  const MyHomePage(title: 'Flutter Demo MQTT Home Page'),
            }));
  }
}
