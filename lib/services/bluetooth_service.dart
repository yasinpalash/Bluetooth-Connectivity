import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService {
  Future<void> requestPermissions() async {
    if (await Permission.bluetooth.isDenied) {
      await Permission.bluetooth.request();
    }

    if (await Permission.locationWhenInUse.isDenied) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future<BluetoothState> getBluetoothState() {
    return FlutterBluetoothSerial.instance.state;
  }

  Stream<BluetoothState> onStateChanged() {
    return FlutterBluetoothSerial.instance.onStateChanged();
  }

  Future<void> enableBluetooth() {
    return FlutterBluetoothSerial.instance.requestEnable();
  }

  Stream<BluetoothDiscoveryResult> startDiscovery() {
    return FlutterBluetoothSerial.instance.startDiscovery();
  }

  Future<List<BluetoothDevice>> getBondedDevices() {
    return FlutterBluetoothSerial.instance.getBondedDevices();
  }

  Future<BluetoothConnection> connectToDevice(String address) {
    return BluetoothConnection.toAddress(address);
  }
}
