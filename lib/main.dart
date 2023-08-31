import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ScanResult> devices = [];

  @override
  void initState() {
    super.initState();
    bluetoothScan();
  }

  bluetoothScan() async{

      if (!(await FlutterBluePlus.isOn)) {
          Fluttertoast.showToast(msg: "Please turn on Your Bluetooth");
      } else {
        // Start scanning for Bluetooth devices
        FlutterBluePlus.scan().listen((scanResult) {
          setState(() {
            devices.add(scanResult);
          });
        });
        FlutterBluePlus.stopScan();
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scan Bluetooth Devices'),
        ),
        body: ListView(

          children: devices.map((device) {
            return Card(
              elevation: 2,
              child: ListTile(
                title: Text(device.device.localName),
                subtitle: Text(device.device.remoteId.toString()),
                onTap: () {
                  device.device.connect().then((value) {
                    Fluttertoast.showToast(
                        msg: "Device connected successfully");
                  }).catchError((error) {
                    print(error.toString());
                    Fluttertoast.showToast(
                        msg:
                            "Failed to connect to device");
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
