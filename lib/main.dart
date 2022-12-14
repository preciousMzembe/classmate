// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:classmate/pages/Home.dart';
import 'package:classmate/pages/Tutorial.dart';
import 'package:classmate/pages/wrapper.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

int? isViewed;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("classmatebox");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt("onBoard");

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 0),
  ));

  // final defaults = <String, dynamic>{"name": '0.0'};
  // await remoteConfig.setDefaults(defaults);

  await remoteConfig.fetchAndActivate();
  // .whenComplete(() {
  //   print("${remoteConfig.getAll()}----------------------");
  //   print("${remoteConfig.getString("name")}----------------------");
  // });

  // await remoteConfig.fetchAndActivate().then((value) {
  if (remoteConfig.getString("vs").isEmpty) {
    print("not found -------------------------------------------------");
  } else {
    print("${remoteConfig.getString('vs')}----------------------");
  }

  //   print("done ----------------------------------------");
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color.fromRGBO(127, 188, 250, 1),
      ),
      debugShowCheckedModeBanner: false,
      home: isViewed != 0 ? Tutorial() : Wrapper(),
    );
  }
}
