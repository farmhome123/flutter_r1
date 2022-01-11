// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
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

class FindDevicesScreen extends StatelessWidget {
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
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
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
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
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
                child: Icon(Icons.search,),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
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

class _DeviceScreenState extends State<DeviceScreen> {
  BluetoothCharacteristic? _characteristic;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  // List<Widget> _buildServiceTiles(List<BluetoothService> services) {
  List<int>? _valueNotify;
  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  Future connect() async {
    final String SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50EBBBBB000";
    final String CHARACTERISTIC_UUID = "6E400003-B5A3-F393-E0A9-E50EBBBBB000";
    int _countPage = 0;
    if (widget.device != null) {
      List<BluetoothService> services = await widget.device.discoverServices();
      print('Connect Success');

      services.forEach((service) async {
        if (service.uuid.toString() == SERVICE_UUID.toString().toLowerCase()) {
          print('##########service.uuid == SERVICE_UUID ################');
          service.characteristics.forEach((characteristic) async {
            _characteristic = characteristic;
            print('_characteristic = ${_characteristic}');
            if (characteristic.uuid.toString() ==
                '6e400003-b5a3-f393-e0a9-e50ebbbbb000'.toLowerCase()) {
              if (characteristic.properties.notify) {
                characteristic.value.listen((value) {
                  if (value != null) {
                    print(_dataParser(value));
                    setState(() {
                      _valueNotify = value;
                    });
                    final command = _dataParser(value).toString();

                    // print('111 ${command[4]} ${command[5]}');
                    if (command.indexOf('RX00') != -1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page1(
                                    valueTx: value,
                                    characteristic: _characteristic!,
                                  )));
                      print('goto page1');
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('RX01') != -1) {
                      if (command[4] == '0') {
                        switch (command[5]) {
                          case '0':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => eco(
                                  valueTx: value,
                                  characteristic: _characteristic!,
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
                                  characteristic: _characteristic!,
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
                                  characteristic: _characteristic!,
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
                                  characteristic: _characteristic!,
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
                    } else if (command.indexOf('RX02') != -1) {
                      print('RX02 ===== ${command[4]}${command[5]}');
                      final value2 = '${command[4]}${command[5]}';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page3(
                                    valueTx: value,
                                    characteristic: _characteristic!,
                                    value: value2,
                                  )));
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('RA') != -1) {
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
                                    characteristic: _characteristic!,
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
                    } else if (command.indexOf('RX02') != -1) {
                      print('RX02 ===== ${command[4]}${command[5]}');
                      final value2 = '${command[4]}${command[5]}';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page3(
                                    valueTx: value,
                                    characteristic: _characteristic!,
                                    value: value2,
                                  )));
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('RX04') != -1) {
                      print('PAGE5');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page5(
                                  valueTx: value,
                                  characteristic: _characteristic!)));
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('RX05') != -1) {
                      print('PAGE 6');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page6(
                                  valueTx: value,
                                  characteristic: _characteristic!)));
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('RX06') != -1) {
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
                                    characteristic: _characteristic!,
                                    value: double.parse(value1),
                                    value1: double.parse(value2),
                                    value2: double.parse(value3),
                                    value3: double.parse(value4),
                                  )));
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('RX07') != -1) {
                      var _value1 =
                          Provider.of<valueProvider>(context, listen: false);
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
                                    characteristic: _characteristic!,
                                    value1: double.parse(value1),
                                    value2: double.parse(value2))));
                      }
                    } else if (command.indexOf('RX08') != -1) {
                      // โหมดคันเร่งอัตโนมัติ
                      print('PAGE 9');
                      final value1 = '${command[4]}${command[5]}';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page9(
                                  valueTx: value,
                                  characteristic: _characteristic!,
                                  value1: int.parse(value1))));
                      setState(() {
                        _countPage = 0;
                      });
                    } else if (command.indexOf('LCX') != -1) {
                      // โหมดล็อคกันขโมย 00 - 01
                      final value1 = '${command[3]}${command[4]}';
                      final value2 = '${command[5]}${command[6]}';
                      final value3 = '${command[7]}${command[8]}';
                      final value4 = '${command[9]}${command[10]}';
                      final value5 = '${command[11]}${command[12]}';
                      print('โหมดล็อคกันขโมย');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => page10(
                                  valueTx: value,
                                  characteristic: _characteristic!,
                                  value1: value1,
                                  value2: value2,
                                  value3: value3,
                                  value4: value4,
                                  value5: value5)));
                      setState(() {
                        _countPage = 0;
                      });
                    }
                    print('_valueNotify ${_valueNotify}');
                  }
                });
                await characteristic
                    .setNotifyValue(!characteristic.isNotifying);
                // Navigator.push(
                //     context,
                //     PageTransition(
                //         type: PageTransitionType.leftToRight,
                //         child: page1(
                //           characteristic: _characteristic,
                //         )));
              }
              // // stream = characteristic.value;
              // //  characteristic.setNotifyValue(!characteristic.isNotifying);
              // stream = characteristic.value;
            } else {
              print('no characteristic');
            }
          });
        } else {
          print('No !!!!!!!!! service.uuid');
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Text(widget.device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
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
                                  connect(),
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
            ],
          ),
        ),
      ),
    );
  }
}
