import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import '../services/bluetooth_service.dart';

class BluetoothController extends GetxController {
  var bluetoothState = BluetoothState.UNKNOWN.obs;
  var devicesList = <BluetoothDiscoveryResult>[].obs;
  var isDiscovering = false.obs;
  var isConnecting = false.obs;
  var isConnected = false.obs;
  BluetoothDevice? selectedDevice;
  BluetoothConnection? connection;

  final BluetoothService _bluetoothService = BluetoothService();

  @override
  void onInit() {
    super.onInit();
    _requestBluetoothPermissions();
    _initializeBluetoothState();
    _listenForBluetoothStateChanges();
  }

  void _requestBluetoothPermissions() {
    _bluetoothService.requestPermissions();
  }

  void _initializeBluetoothState() {
    _bluetoothService.getBluetoothState().then((state) {
      bluetoothState.value = state;
      if (bluetoothState.value == BluetoothState.STATE_OFF) {
        _bluetoothService.enableBluetooth();
      }
    });
  }

  void _listenForBluetoothStateChanges() {
    _bluetoothService.onStateChanged().listen((state) {
      bluetoothState.value = state;
    });
  }

  void startDiscovery() {
    if (bluetoothState.value == BluetoothState.STATE_OFF) {
      _bluetoothService.enableBluetooth().then((_) {
        if (bluetoothState.value != BluetoothState.STATE_ON) {
          Get.snackbar('Bluetooth', 'Please enable Bluetooth to proceed.');
          return;
        }
      });
    }

    isDiscovering.value = true;
    devicesList.clear();

    _bluetoothService.startDiscovery().listen((result) {
      devicesList.add(result);
    }).onDone(() {
      isDiscovering.value = false;
    });
  }

  void getBondedDevices() async {
    var devices = await _bluetoothService.getBondedDevices();
    devices.forEach((device) {
      print('Paired device: ${device.name} (${device.address})');
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    isConnecting.value = true;
    selectedDevice = device;

    try {
      connection = await _bluetoothService.connectToDevice(device.address);
      isConnected.value = true;

      connection!.input?.listen((Uint8List data) {
        print('Data incoming: ${String.fromCharCodes(data)}');
      }).onDone(() {
        isConnected.value = false;
      });
    } catch (exception) {
      isConnected.value = false;
    } finally {
      isConnecting.value = false;
    }
  }

  void disconnectFromDevice() {
    if (connection != null && connection!.isConnected) {
      connection!.finish();
      isConnected.value = false;
      selectedDevice = null;
    }
  }
}