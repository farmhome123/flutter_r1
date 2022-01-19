import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torqueair/page1.dart';
import 'package:torqueair/page10.dart';
import 'package:torqueair/page2.dart';
import 'package:torqueair/page3.dart';
import 'package:torqueair/page4.dart';
import 'package:torqueair/page5.dart';
import 'package:torqueair/page6.dart';
import 'package:torqueair/page7.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/page9.dart';
import 'package:torqueair/sport2.dart';
import 'package:torqueair/valueProvider.dart';
import 'package:torqueair/widgets.dart';

import 'comfort.dart';
import 'eco.dart';

void main() {
  runApp(SettingBle());
}

class SettingBle extends StatelessWidget {
  BluetoothCharacteristic? _characteristic;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  final String NAME_DIVCE = "r1 store";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Text('Search Devices'),
        leading: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => page1(
                          characteristic: null,
                        )));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                      child: Text('OPEN'),
                                      onPressed: () => {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeviceScreen(
                                                            device: d))),
                                          });
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),

              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!.map((r) {
                    if (r.device.name
                        .toLowerCase()
                        .contains(NAME_DIVCE.toLowerCase())) {
                      return ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                r.device.connect();
                                return DeviceScreen(device: r.device);
                              })));
                    } else {
                      return SizedBox();
                    }
                  }).toList(),
                ),
              ),
              // StreamBuilder<List<ScanResult>>(
              //   stream: FlutterBlue.instance.scanResults,
              //   initialData: [],
              //   builder: (c, snapshot) => Column(
              //     children: snapshot.data!
              //         .map(
              //           (r) => ScanResultTile(
              //             result: r,
              //             onTap: () => Navigator.of(context)
              //                 .push(MaterialPageRoute(builder: (context) {
              //               r.device.connect();
              //               return DeviceScreen(device: r.device);
              //             })),
              //           ),
              //         )
              //         .toList(),
              //   ),
              // ),
            ],
          ),
        ),
      ),

      //   /////////// find name device bluetooth
      // if(result.device.name == "ESP-01"){
      //   print('name ESP-32 successfuly');
      // }
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.search,
              ),
              onPressed: () => FlutterBlue.instance.startScan(
                timeout: Duration(seconds: 4),
              ),

              // onPressed: finddveicename,
            );
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

BluetoothCharacteristic? _characteristicTX;
BluetoothCharacteristic? _characteristicRX;
// late BluetoothService _bleService;
BluetoothService? _bleService;

class _DeviceScreenState extends State<DeviceScreen> {
  // List<Widget> _buildServiceTiles(List<BluetoothService> services) {
  List<int>? _valueNotify;
  String? genuidble;
  String? uidble;
  int _countPage = 0;

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  checkConnectDevice() async {
    var connectDevices = await FlutterBlue.instance.connectedDevices;
    for (var device in connectDevices) {
      print(device.name);
      device.disconnect();
    }
  }

  final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
  final String CHARACTERISTIC_UUID_TX = "0000ffe1-0000-1000-8000-00805f9b34fb";
  final String CHARACTERISTIC_UUID_RX = "0000ffe1-0000-1000-8000-00805f9b34fb";
  void _handleBleValue() async {
    // int index = context.watch<valueProvider>().count;
    var dataProtocal = {
      1: [
        'HY0103000200#',
        'HY0203000200#',
        'HY0303000200#',
        'HY0403000200#',
        'HY0503000200#',
        'HY0603000200#'
      ],
      2: [
        'HY0102000260#',
        'HY0202000260#',
        'HY0302000260#',
        'HY0402000260#',
        'HY0502000260#',
        'HY0602000260#',
      ],
      3: [
        'HY0102000320#',
        'HY0202000320#',
        'HY0302000320#',
        'HY0402000320#',
        'HY0502000320#',
        'HY0602000320#'
      ],
      4: [
        'HY0102000380#',
        'HY0202000380#',
        'HY0302000380#',
        'HY0402000380#',
        'HY0502000380#',
        'HY0602000380#',
      ],
      5: [
        'HY0102000440#',
        'HY0202000440#',
        'HY0302000440#',
        'HY0402000440#',
        'HY0502000440#',
        'HY0602000440#',
      ],
      6: [
        'HY0102000500#',
        'HY0202000500#',
        'HY0302000500#',
        'HY0402000500#',
        'HY0502000500#',
        'HY0602000500#',
      ],
      7: [
        'HY0102000560#',
        'HY0202000560#',
        'HY0302000560#',
        'HY0402000560#',
        'HY0502000560#',
        'HY0602000560#',
      ],
      8: [
        'HY0102000620#',
        'HY0202000620#',
        'HY0302000620#',
        'HY0402000620#',
        'HY0502000620#',
        'HY0602000620#',
      ],
      9: [
        'HY0102000680#',
        'HY0202000680#',
        'HY0302000680#',
        'HY0402000680#',
        'HY0502000680#',
        'HY0602000680#',
      ],
      10: [
        'HY0102000740#',
        'HY0202000740#',
        'HY0302000740#',
        'HY0402000740#',
        'HY0502000740#',
        'HY0602000740#',
      ],
      11: [
        'HY0102000800#',
        'HY0202000800#',
        'HY0302000800#',
        'HY0402000800#',
        'HY0502000800#',
        'HY0602000800#',
      ],
      12: [
        'HY0102000860#',
        'HY0202000860#',
        'HY0302000860#',
        'HY0402000860#',
        'HY0502000860#',
        'HY0602000860#',
      ],
      13: [
        'HY0102000860#',
        'HY0202000860#',
        'HY0302000860#',
        'HY0402000860#',
        'HY0502000860#',
        'HY0602000860#',
      ],
      14: [
        'HY0102000980#',
        'HY0202000980#',
        'HY0302000980#',
        'HY0402000980#',
        'HY0502000980#',
        'HY0602000980#',
      ],
      15: [
        'HY0101001000#',
        'HY0201001000#',
        'HY0301001000#',
        'HY0401001000#',
        'HY0501001000#',
        'HY0601001000#',
      ],
      16: [
        'HY0101000300#',
        'HY0201000300#',
        'HY0301000300#',
        'HY0401000300#',
        'HY0501000300#',
        'HY0601000300#',
      ],
      17: [
        'HY0101000200#',
        'HY0201000200#',
        'HY0301000200#',
        'HY0401000200#',
        'HY0501000200#',
        'HY0601000200#',
      ],
      18: [
        'HY0101000100#',
        'HY0201000200#',
        'HY0301000100#',
        'HY0401000200#',
        'HY0501000100#',
        'HY0601000200#',
      ],
      19: [
        'HY0100500100#',
        'HY0201000150#',
        'HY0300500100#',
        'HY0401000150#',
        'HY0500500100#',
        'HY0601000150#',
      ],
      20: [
        'HY0100500100#',
        'HY0201000150#',
        'HY0300500100#',
        'HY0401000150#',
        'HY0500500100#',
        'HY0601000150#',
      ],
      21: [
        'HY0101002500#',
        'HY0201000500#',
        'HY0301000500#',
        'HY0401000500#',
        'HY0501002500#',
        'HY0601000550#',
      ],
      22: [
        'HY0101000500#',
        'HY0201002500#',
        'HY0301000500#',
        'HY0401000500#',
        'HY0501000500#',
        'HY0601002500#',
      ],
      23: [
        'HY0101000250#',
        'HY0201001500#',
        'HY0301000250#',
        'HY0401000250#',
        'HY0501000250#',
        'HY0601002500#',
      ],
      24: [
        'HY0101000200#',
        'HY0201000200#',
        'HY0301002500#',
        'HY0401002500#',
        'HY0501000200#',
        'HY0601000200#',
      ],
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_bleService == null) return;
    var charateristics = _bleService!.characteristics;
    charateristics.forEach((charateristic) {
      if (charateristic.uuid.toString().toLowerCase() ==
          CHARACTERISTIC_UUID_TX.toString().toLowerCase()) {
        _characteristicTX = charateristic;
      }
      if (charateristic.uuid.toString().toLowerCase() ==
          CHARACTERISTIC_UUID_RX.toString().toLowerCase()) {
        _characteristicRX = charateristic;
      }
    });

    if (_characteristicTX != null) {
      _characteristicTX!.setNotifyValue(true);

      _characteristicTX!.value.listen((value) async {
        print(_dataParser(value));
        final command = _dataParser(value).toString();

        if (command.contains('RX00')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page1(
                        valueTx: value,
                        characteristic: _characteristicTX!,
                      )));
          print('goto page1');
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RX01')) {
          if (command[4] == '0') {
            switch (command[5]) {
              case '0':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => eco(
                      valueTx: value,
                      characteristic: _characteristicTX!,
                    ),
                  ),
                );
                setState(() {
                  _countPage = 0;
                });
                break;
              case '1':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => comfort(
                      valueTx: value,
                      characteristic: _characteristicTX!,
                    ),
                  ),
                );
                setState(() {
                  _countPage = 0;
                });
                break;
              case '2':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => page2(
                      valueTx: value,
                      characteristic: _characteristicTX!,
                    ),
                  ),
                );
                setState(() {
                  _countPage = 0;
                });
                break;
              case '3':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => sport2(
                      valueTx: value,
                      characteristic: _characteristicTX!,
                    ),
                  ),
                );
                setState(() {
                  _countPage = 0;
                });
                break;
            }
          }

          print('111 ${command[4]} ${command[5]}');
        } else if (command.contains('RX02')) {
          print('RX02 ===== ${command[4]}${command[5]}');
          final value2 = '${command[4]}${command[5]}';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page3(
                        valueTx: value,
                        characteristic: _characteristicTX!,
                        value: value2,
                      )));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RA')) {
          print('command = ${command}');
          final value1 = '${command[2]}${command[3]}';
          final value2 = '${command[4]}${command[5]}';
          final value3 = '${command[6]}${command[7]}';
          final value4 = '${command[8]}${command[9]}';
          final value5 = '${command[10]}${command[11]}';
          final value6 = '${command[12]}${command[13]}';
          final value7 = '${command[14]}${command[15]}';
          final value8 = '${command[16]}${command[17]}';
          final value9 = '${command[18]}${command[19]}';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page4(
                        valueTx: value,
                        characteristic: _characteristicTX!,
                        value1: double.parse(value1),
                        value2: double.parse(value2),
                        value3: double.parse(value3),
                        value4: double.parse(value4),
                        value5: double.parse(value5),
                        value6: double.parse(value6),
                        value7: double.parse(value7),
                        value8: double.parse(value8),
                        value9: double.parse(value9),
                      )));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RX02')) {
          print('RX02 ===== ${command[4]}${command[5]}');
          final value2 = '${command[4]}${command[5]}';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page3(
                        valueTx: value,
                        characteristic: _characteristicTX!,
                        value: value2,
                      )));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RX04')) {
          print('PAGE5');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page5(
                      valueTx: value, characteristic: _characteristicTX!)));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RX05')) {
          print('PAGE 6');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page6(
                      valueTx: value, characteristic: _characteristicTX!)));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RX06')) {
          // โหมดเดินหอบ
          print('PAGE 7');
          final value1 = '${command[4]}${command[5]}';
          final value2 = '${command[6]}${command[7]}';
          final value3 = '${command[8]}${command[9]}';
          final value4 = '${command[10]}${command[11]}';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page7(
                        valueTx: value,
                        characteristic: _characteristicTX!,
                        value: double.parse(value1),
                        value1: double.parse(value2),
                        value2: double.parse(value3),
                        value3: double.parse(value4),
                      )));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('RX07')) {
          var _value1 = Provider.of<valueProvider>(context, listen: false);
          // โหมดปิดควันดำ
          setState(() {
            if (_countPage < 2) {
              _countPage++;
            }
          });
          print('PAGE 8');
          final value1 = '${command[4]}${command[5]}';
          final value2 = '${command[6]}${command[7]}';
          // setState(() {
          //   _value1.value1 = double.parse(value1.toString());
          //   _value1.value2 = double.parse(value2.toString());
          var value1PRO = double.parse(value1.toString());
          var value2PRO = double.parse(value2.toString());
          setState(() {
            _value1.increment(value1PRO, value2PRO);
          });

          // }); _value1.increment(value1, value2);
          print('///////////_value1.value1 = ${_value1.value1}');
          print('///////////_value1.value2 = ${_value1.value2}');
          print('_countPage = ${_countPage}');

          if (_countPage <= 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => page8(
                        valueTx: value,
                        characteristic: _characteristicTX!,
                        value1: double.parse(value1),
                        value2: double.parse(value2))));
          }
        } else if (command.contains('RX08')) {
          // โหมดคันเร่งอัตโนมัติ
          print('PAGE 9');
          final value1 = '${command[4]}${command[5]}';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page9(
                      valueTx: value,
                      characteristic: _characteristicTX!,
                      value1: int.parse(value1))));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('LCX')) {
          // โหมดล็อคกันขโมย 00 - 01
          final value1 = '${command[3]}${command[4]}';
          print('โหมดล็อคกันขโมย');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => page10(
                      valueTx: value,
                      characteristic: _characteristicTX!,
                      value1: value1)));
          setState(() {
            _countPage = 0;
          });
        } else if (command.contains('CN')) {
          final value1 = '${command[2]}${command[3]}';
          // _showDialogTestText(context);

          if (command.contains('01#')) {
            widget.device.discoverServices();
            if (uidble == '') {
              prefs.setString('uidble', '${genuidble.toString()}');
            }
            sendData('REQ#');
          } else {
            checkConnectDevice();
            _showDialog(context);
          }
          // if (value1 == '01') {
          //   widget.device.discoverServices();
          //   if (uidble == '') {
          //     prefs.setString('uidble', '${genuidble.toString()}');
          //   }
          //   sendPage();
          // } else {
          //   checkConnectDevice();
          //   _showDialog(context);
          // }
        }
      });
    }
    if (_characteristicRX != null) {
      // _characteristicRX!.write(utf8.encode('Test'));

    }
  }

  Future connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await checkConnectDevice();
    await widget.device.connect();
    await widget.device.discoverServices();

    var res = FlutterBlue.instance.connectedDevices;
    print(res);
    int _countPage = 0;
    // List<BluetoothService> services = await widget.device.discoverServices();
    widget.device.discoverServices().then((services) => {
          services.forEach((service) {
            print("server uuid ===>" + service.uuid.toString());
            if (service.uuid.toString().toLowerCase() ==
                SERVICE_UUID.toLowerCase()) {
              print("service ====>" + services.toString());
              _bleService = service;
              _handleBleValue();
            }
          })
        });
  }

  getUIDBLE() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uidble = prefs.getString('uidble');
    print('###################### UIDBLE ===> ${uidble}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUIDBLE();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Text(widget.device.name),
        leading: FlatButton(
            onPressed: () async {
              if (_characteristicTX != null) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                uidble = await prefs.getString('uidble');
                print('UID BLE = ${uidble}');
                if (uidble == '') {
                  setState(() {
                    genuidble = randomNumeric(6);
                  });
                  await _characteristicTX!
                      .write(utf8.encode('NID=${genuidble}#'));
                } else {
                  sendData('OID=${uidble}#');
                  await _characteristicTX!.write(utf8.encode('OID=${uidble}#'));
                }
                print('############ uidble == > ${uidble}');
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => page1(
                              characteristic: null,
                            )));
              }

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => page1(
              //               characteristic: null,
              //             )));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () async {
                    await widget.device.disconnect();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingBle()));
                  };
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () async {
                    await checkConnectDevice();
                    await widget.device.connect();
                    await widget.device.discoverServices();
                  };
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              StreamBuilder<BluetoothDeviceState>(
                stream: widget.device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) => ListTile(
                  leading: (snapshot.data == BluetoothDeviceState.connected)
                      ? Icon(Icons.bluetooth_connected)
                      : Icon(Icons.bluetooth_disabled),
                  title: Text(
                      'Device is ${snapshot.data.toString().split('.')[1]}.'),
                  subtitle: Text('${widget.device.id}'),
                  trailing: StreamBuilder<bool>(
                    stream: widget.device.isDiscoveringServices,
                    initialData: false,
                    builder: (c, snapshot) => IndexedStack(
                      index: snapshot.data! ? 1 : 0,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => {
                                  widget.device.discoverServices(),
                                  // connect(),
                                }),
                        IconButton(
                          icon: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.grey),
                            ),
                            width: 18.0,
                            height: 18.0,
                          ),
                          onPressed: null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // StreamBuilder<int>(
              //   stream: widget.device.mtu,
              //   initialData: 0,
              //   builder: (c, snapshot) => ListTile(
              //     title: Text('MTU Size'),
              //     subtitle: Text('${snapshot.data} bytes'),
              //     trailing: IconButton(
              //       icon: Icon(Icons.edit),
              //       onPressed: () => widget.device.requestMtu(223),
              //     ),
              //   ),
              // ),
              FlatButton(
                  onPressed: () {
                    //  _characteristicTX!.write(utf8.encode('Test'));

                    if (_characteristicTX != null) {
                      // print('_characteristicTX -------> null');
                      // _characteristicTX!.write(utf8.encode('Test'));
                      sendData('Test sendData');
                    } else {
                      print('_characteristicTX -------> null');
                    }
                    // print('Test');
                  },
                  child: Text('sendData')),
            ],
          ),
        ),
      ),
    );
  }

  sendData(String value) async {
    if (_characteristicTX != null) {
      _characteristicTX!.write(utf8.encode(value));
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("แจ้งเตือน"),
          content: new Text("การเชื่อมต่อล้มเหลว"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => page1(
                              characteristic: null,
                            )));
              },
            ),
          ],
        );
      },
    );
  }
}
