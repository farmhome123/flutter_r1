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
import 'package:torqueair/page7.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/page9.dart';
import 'package:torqueair/settingble.dart';

class page6 extends StatefulWidget {
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page6({Key? key, this.valueTx, required this.characteristic})
      : super(key: key);

  @override
  _page6State createState() => _page6State();
}

class _page6State extends State<page6> {
  BluetoothCharacteristic? characteristic;
  bool isSwitched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('โหมด กันลื่นไถล ');
    print('send to esp RY05#');
    characteristic = widget.characteristic;
  }

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
                        "โหมดกันลื่นไถล",
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
            SizedBox(
              height: 20,
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Container(
                height: 270,
                child: Column(
                  children: [
                    Image.asset(
                      'lib/item/กันลื่น.png',
                      height: 180,
                      width: 200,
                    ),
                    Text(
                      "โหมดกันลื่นไถล",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      "กำลังประมวลผลปรับปรับลดความไวคันเร่ง",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      "เพื่อป้องกันการลื่นไหล",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
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
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => page1(
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
                  onPressed: () {         if (characteristic != null) {
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
                    // widget.characteristic!.write(utf8.encode('RY05#'));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page6(
                    //               characteristic: widget.characteristic,
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon6.1.png'),
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
                  onPressed: () {         if (characteristic != null) {
                    widget.characteristic!.write(utf8.encode('RY07#'));}
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
                  onPressed: () {         if (characteristic != null) {
                    widget.characteristic!.write(utf8.encode('RY08#'));}
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
