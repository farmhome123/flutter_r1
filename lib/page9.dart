import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:torqueair/Navbar.dart';
import 'package:torqueair/page1.dart';
import 'package:torqueair/page10.dart';
import 'package:torqueair/page2.dart';
import 'package:torqueair/page3.dart';
import 'package:torqueair/page4.dart';
import 'package:torqueair/page5.dart';
import 'package:torqueair/page6.dart';
import 'package:torqueair/page7.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/settingble.dart';

class page9 extends StatefulWidget {
  final int value1;

  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page9({
    Key? key,
    this.valueTx,
    required this.characteristic,
    required this.value1,
  }) : super(key: key);

  @override
  _page9State createState() => _page9State();
}

class _page9State extends State<page9> {
  int number = 0;
  bool isSwitched = false;
  BluetoothCharacteristic? characteristic;
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
      number = widget.value1;
      characteristic = widget.characteristic;
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
                        "โหมดคันเร่งอัตโนมัติ",
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
              child: Container(
                height: 270,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("lib/item/max.png")),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              number.toString(),
                              style: TextStyle(
                                  fontFamily: 'ethnocentric',
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.red,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                    Shadow(
                                      color: Colors.red,
                                      blurRadius: 10.0,
                                      offset: Offset(-3.0, 3.0),
                                    ),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "STEP",
                              style: TextStyle(
                                  fontFamily: 'ethnocentric',
                                  fontSize: 15,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.red,
                                      offset: Offset(3.0, 3.0),
                                    ),
                                    Shadow(
                                      color: Colors.red,
                                      blurRadius: 10.0,
                                      offset: Offset(-3.0, 3.0),
                                    ),
                                  ]),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (number > 0) {
                                number--;
                              }
                              if (characteristic != null) {
                                widget.characteristic!.write(utf8.encode(
                                  'RY08${number.toString().padLeft(2, '0')}#',
                                ));
                              }
                            });
                          },
                          icon: Image.asset('lib/item/minus.png'),
                          iconSize: 60,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('lib/item/slide.png'),
                          iconSize: 80,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (number < 99) {
                                number++;
                              }
                              if (characteristic != null) {
                                widget.characteristic!.write(utf8.encode(
                                  'RY08${number.toString().padLeft(2, '0')}#',
                                ));
                              }
                            });
                          },
                          icon: Image.asset('lib/item/plus.png'),
                          iconSize: 60,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: Column(
                      children: [
                        Text(
                          'send to esp RY0801${number.toString().padLeft(2, '0')}#',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "โหมดคันเร่งอัตโนมัติ",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 15),
                        ),
                        Text(
                          "จะทำการเหยียบคันเร่งให้โดยอัตโนมัติตามตำแหน่งที่มีการปรับแต่งการตั้งค่า",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 10),
                        ),
                        Text(
                          "ใช้เพื่อชาร์จแบตเตอรี่หรือวอร์มเครื่องยนต์รวมถึงใช้กับ Winch",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 10),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY00#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page1(
                                    characteristic: widget.characteristic,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon1.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY01#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page2(
                                    characteristic: widget.characteristic,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon2.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY02#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page3(
                                    value: '0',
                                    characteristic: widget.characteristic,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon3.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RB#'));
                    } else {
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
                    }
                  },
                  icon: Image.asset('lib/img/icon4.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY04#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page5(
                                    characteristic: widget.characteristic,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon5.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY05#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page6(
                                    characteristic: widget.characteristic,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon6.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY06#'));
                    } else {
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
                    }
                  },
                  icon: Image.asset('lib/img/icon7.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY07#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page8(
                                    characteristic: widget.characteristic,
                                    value1: 0,
                                    value2: 0,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon8.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // widget.characteristic!.write(utf8.encode('RY08#'));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page9(
                    //               characteristic: widget.characteristic,
                    //               value1: 0,
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon9.1.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // if (characteristic != null) {
                    // } else {
                    // }
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
