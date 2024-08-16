import 'package:flutter/material.dart';
import 'package:fvmmm/views/bluetooth_home_screen.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: const  AppBarTheme(color: Colors.blueAccent)
      ),
      home: BluetoothHomeScreen(),
    );
  }
}
