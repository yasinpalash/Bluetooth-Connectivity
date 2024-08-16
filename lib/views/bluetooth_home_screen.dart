import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import '../controllers/bluetooth_controller.dart';

class BluetoothHomeScreen extends StatelessWidget {
  final BluetoothController controller = Get.put(BluetoothController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Bluetooth Connectivity",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => bluetoothStateCard(controller.bluetoothState.value)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.isDiscovering.value
                      ? null
                      : controller.startDiscovery,
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  label:
                      const Text("Scan", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.getBondedDevices,
                  icon: const Icon(
                    Icons.bluetooth,
                    color: Colors.white,
                  ),
                  label: const Text("Paired Devices",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: deviceList()),
          ],
        ),
      ),
    );
  }

  Widget bluetoothStateCard(BluetoothState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Bluetooth State:", style: TextStyle(fontSize: 16)),
            Text(
              state.toString().split('.')[1],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: state == BluetoothState.STATE_ON
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deviceList() {
    return Obx(() {
      if (controller.isConnecting.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.isConnected.value) {
        return connectedDeviceCard();
      } else if (controller.devicesList.isEmpty) {
        return const Center(child: Text("No devices found"));
      } else {
        return ListView.builder(
          itemCount: controller.devicesList.length,
          itemBuilder: (context, index) {
            BluetoothDiscoveryResult result = controller.devicesList[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(result.device.name ?? "Unknown Device"),
                subtitle: Text(result.device.address),
                trailing: const Icon(Icons.bluetooth, color: Colors.blueAccent),
                onTap: () => controller.connectToDevice(result.device),
              ),
            );
          },
        );
      }
    });
  }

  Widget connectedDeviceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected to ${controller.selectedDevice?.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: controller.disconnectFromDevice,
              icon: const Icon(Icons.bluetooth_disabled),
              label: const Text("Disconnect"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
