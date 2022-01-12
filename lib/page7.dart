import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_switch/flutter_switch.dart';


import 'package:torqueair/Navbar.dart';
import 'package:torqueair/page1.dart';
import 'package:torqueair/page10.dart';
import 'package:torqueair/page2.dart';
import 'package:torqueair/page3.dart';
import 'package:torqueair/page4.dart';
import 'package:torqueair/page5.dart';
import 'package:torqueair/page6.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/page9.dart';
import 'package:torqueair/settingble.dart';

class page7 extends StatefulWidget {
  final double value;
  final double value1;
  final double value2;
  final double value3;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page7({
    Key? key,
    this.valueTx,
    required this.characteristic,
    required this.value,
    required this.value1,
    required this.value2,
    required this.value3,
  }) : super(key: key);

  @override
  _page7State createState() => _page7State();
}

class _page7State extends State<page7> {
  bool isSwitched = false;
  final double minlevel = 0;
  final double maxlevel = 24;
  final double minsound = 0;
  final double maxsound = 50;
  final double mintime = 0;
  final double maxtime = 60;
  double? value;
  double value1 = 10;
  double value2 = 10;
  double value3 = 10;
  BluetoothCharacteristic? characteristic;
  bool status = false;
  @override
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Bluetooth"),
          content: new Text("โปรดเชื่อมต่อบลูทูธ"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      status = widget.value == 0 ? false : true;
      value = widget.value;
      value1 = widget.value1;
      value2 = widget.value2;
      value3 = widget.value3;
      characteristic = widget.characteristic;
    });
  }

  @override
  Widget build(BuildContext context) {
    var statusval;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Image.asset(
          'lib/img/logo.png',
          height: 200,
          width: 200,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingBle()));
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.leftToRight,
              //         child: SettingBle()));
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage("lib/itemol/BGJPG.jpg"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              child: Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.red.shade900),
                        bottom: BorderSide(color: Colors.red.shade900)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "โหมดเดินหอบ",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Kanit',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 30, bottom: 0),
                  child: FlutterSwitch(
                    activeColor: Colors.red[900]!,
                    toggleColor: Colors.white,
                    valueFontSize: 10.0,
                    height: 25,
                    width: 60,
                    value: status,
                    borderRadius: 30.0,
                    padding: 5.0,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        status = val;
                        print(status);
                        statusval = val == true ? '01' : '00';
                        print(statusval);
                        if (characteristic != null) {
                          // status.toString().padLeft(2, '0')
                          widget.characteristic!.write(
                            utf8.encode(
                                'RY06${'${statusval}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                          );
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 15),
                child: Wrap(
                  children: [
                    Container(
                      height: 200,
                      child: Wrap(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 70,
                              thumbShape: SliderComponentShape.noOverlay,
                              overlayShape: SliderComponentShape.noOverlay,
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.grey[800],
                            ),
                            child: Container(
                              height: 270,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${value1.round()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height:  5,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value1,
                                                    activeColor: Colors.white,
                                                    min: minlevel,
                                                    max: maxlevel,
                                                    divisions: 20,
                                                    label: value1
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value1) =>
                                                        setState(() => this
                                                            .value1 = value1),
                                                    onChangeEnd: (value1) => {
                                                      print(
                                                          'RY06${1.toString().padLeft(2, '0') + '${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                      if (widget
                                                              .characteristic !=
                                                          null)
                                                        {
                                                          widget.characteristic!
                                                              .write(
                                                            utf8.encode(
                                                                'RY06${'${status == true ? '01' : '00'}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                          ),
                                                        }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                            'lib/item/signal.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            'ระดับ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${value2.round()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value2,
                                                    activeColor: Colors.white,
                                                    min: minsound,
                                                    max: maxsound,
                                                    divisions: 20,
                                                    label: value2
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value2) =>
                                                        setState(() => this
                                                            .value2 = value2),
                                                    onChangeEnd: (value2) => {
                                                      print(
                                                          'RY06${1.toString().padLeft(2, '0') + '${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                      if (characteristic !=
                                                          null)
                                                        {
                                                          widget.characteristic!
                                                              .write(
                                                            utf8.encode(
                                                                'RY06${'${status == true ? '01' : '00'}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                          ),
                                                        }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                            'lib/item/sound.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            'ความดัง',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${value3.round()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'ethnocentric',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Slider(
                                                    value: value3,
                                                    activeColor: Colors.white,
                                                    min: mintime,
                                                    max: maxtime,
                                                    divisions: 20,
                                                    label: value3
                                                        .round()
                                                        .toString(),
                                                    onChanged: (value3) =>
                                                        setState(() => this
                                                            .value3 = value3),
                                                    onChangeEnd: (value3) => {
                                                      print(
                                                          'RY06${1.toString().padLeft(2, '0') + '${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                      if (characteristic !=
                                                          null)
                                                        {
                                                          widget.characteristic!
                                                              .write(
                                                            utf8.encode(
                                                                'RY06${'${status == true ? '01' : '00'}${value1.toStringAsFixed(0).padLeft(2, '0')}' + '${value2.toStringAsFixed(0).padLeft(2, '0')}' + '${value3.toStringAsFixed(0).padLeft(2, '0')}'}#'),
                                                          ),
                                                        }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                            'lib/item/clock.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            'ตั้งเวลา',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "โหมดเดินหอบ",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  "สามารถเลือกปรับได้ตามความต้องการ",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
            Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY00#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page1(
                                  characteristic: widget.characteristic,
                                )));
                  },
                  icon: Image.asset('lib/img/icon1.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY01#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page2(
                                  characteristic: widget.characteristic,
                                )));
                  },
                  icon: Image.asset('lib/img/icon2.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY02#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page3(
                                  value: '0',
                                  characteristic: widget.characteristic,
                                )));
                  },
                  icon: Image.asset('lib/img/icon3.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RB#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page4(
                                  characteristic: widget.characteristic,
                                  value1: 0,
                                  value3: 0,
                                  value2: 0,
                                  value4: 0,
                                  value5: 0,
                                  value6: 0,
                                  value7: 0,
                                  value8: 0,
                                  value9: 0,
                                )));
                  },
                  icon: Image.asset('lib/img/icon4.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY04#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page5(
                                  characteristic: widget.characteristic,
                                )));
                  },
                  icon: Image.asset('lib/img/icon5.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY05#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page6(
                                  characteristic: widget.characteristic,
                                )));
                  },
                  icon: Image.asset('lib/img/icon6.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // widget.characteristic!.write(utf8.encode('RY06#'));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page7(
                    //               characteristic: widget.characteristic,
                    //               value: 0,
                    //               value1: 0,
                    //               value2: 0,
                    //               value3: 0,
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon7.1.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY07#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page8(
                                  characteristic: widget.characteristic,
                                  value1: 0,
                                  value2: 0,
                                )));
                  },
                  icon: Image.asset('lib/img/icon8.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY08#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page9(
                                  characteristic: widget.characteristic,
                                  value1: 0,
                                )));
                  },
                  icon: Image.asset('lib/img/icon9.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page10(
                                  characteristic: widget.characteristic,
                                  value1: '',
                                  value2: '',
                                  value3: '',
                                  value4: '',
                                  value5: '',
                                )));
                  },
                  icon: Image.asset('lib/img/icon10.png'),
                  iconSize: 70,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
