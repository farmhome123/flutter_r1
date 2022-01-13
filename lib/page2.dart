import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:torqueair/Navbar.dart';
import 'package:torqueair/comfort.dart';
import 'package:torqueair/eco.dart';
import 'package:torqueair/page1.dart';
import 'package:torqueair/page10.dart';
import 'package:torqueair/page3.dart';
import 'package:torqueair/page4.dart';
import 'package:torqueair/page5.dart';
import 'package:torqueair/page6.dart';
import 'package:torqueair/page7.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/page9.dart';
import 'package:torqueair/settingble.dart';
import 'package:torqueair/sport2.dart';

class page2 extends StatefulWidget {
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page2({Key? key, this.valueTx, required this.characteristic})
      : super(key: key);

  @override
  _page2State createState() => _page2State();
}

class _page2State extends State<page2> {
  BluetoothCharacteristic? characteristic;
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
      setState(() {
        characteristic = widget.characteristic;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        "โหมดคันเร่งอัจฉริยะ",
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
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 270,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage("lib/item/ai.png")),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'lib/item/SPORT2.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (characteristic != null) {
                                          widget.characteristic!
                                              .write(utf8.encode('RY0101#'));
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => comfort(
                                                    characteristic:
                                                        characteristic)));
                                      },
                                      icon:
                                          Image.asset('lib/item/COMFORT1.png'),
                                      iconSize: 60,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (characteristic != null) {
                                          widget.characteristic!
                                              .write(utf8.encode('RY0103#'));
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => sport2(
                                                    characteristic:
                                                        characteristic)));
                                      },
                                      icon: Image.asset('lib/item/SPORT+1.png'),
                                      iconSize: 60,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (characteristic != null) {
                                          widget.characteristic!
                                              .write(utf8.encode('RY0100#'));
                                        }
                                     Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => eco(
                                                    characteristic:
                                                        characteristic)));
                                      },
                                      icon: Image.asset('lib/item/ECO1.png'),
                                      iconSize: 60,
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
                  Text(
                    'โหมด Ai Sport',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, fontFamily: 'Kanit'),
                  ),
                  Text(
                    'โหมดนี้จะปรับคันเร่งให้มีความรู้สึกไวขึ้น',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, fontFamily: 'Kanit'),
                  ),
                  Text(
                    'ให้ความรู้สึกสปร์ต',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, fontFamily: 'Kanit'),
                  ),
                ],
              ),
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
                    // if (characteristic == null) {
                    //   _showDialog(context);
                    // } else {
                    //   widget.characteristic!.write(utf8.encode('RY01#'));
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => page2(
                    //                 characteristic: widget.characteristic,
                    //               )));
                    // }
                  },
                  icon: Image.asset('lib/img/icon2.1.png'),
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
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY06#'));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => page7(
                                  characteristic: widget.characteristic,
                                  value: 0,
                                  value1: 0,
                                  value2: 0,
                                  value3: 0,
                                )));
                  },
                  icon: Image.asset('lib/img/icon7.png'),
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
