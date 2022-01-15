import 'dart:convert' show utf8;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';

import 'package:torqueair/Navbar.dart';
import 'package:torqueair/page10.dart';
import 'package:torqueair/page2.dart';
import 'package:torqueair/page3.dart';
import 'package:torqueair/page4.dart';
import 'package:torqueair/page5.dart';
import 'package:torqueair/page6.dart';
import 'package:torqueair/page7.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/page9.dart';
import 'package:torqueair/settingble.dart';

class page1 extends StatefulWidget {
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page1({Key? key, this.valueTx, required this.characteristic})
      : super(key: key);

  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  BluetoothCharacteristic? characteristic;
  double? speed;
  double? speed2;
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
    checkPermission();
    print('โหมด  AI SPORT');
    print('send to esp RY0102#');
    setState(() {
      setState(() {
        characteristic = widget.characteristic;
      });
    });
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Localtion Service ปิดอยู่ ?'),
              content: Text('กรุณาเปิด Localtion Service'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    exit(0);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Find LatLang
          findSpeed();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Localtion Service ปิดอยู่ ?'),
              content: Text('กรุณาเปิด Localtion Service'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    exit(0);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Find LatLng
          findSpeed();
        }
      }
    } else {
      print('Service Location Close');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Localtion Service ปิดอยู่ ?'),
          content: Text('กรุณาเปิด Localtion Service'),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                exit(0);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<Null?> findSpeed() async {
    print('Find findSpeed');
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      print('locationSettings :android ');
      locationSettings = AndroidSettings(
        // accuracy: LocationAccuracy.best,
        // distanceFilter: 2,
        // forceLocationManager: false,
        intervalDuration: const Duration(milliseconds: 500),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
      );
    } else {
      print('locationSettings orter');
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((position) {
      var speedInMps = position.speed; // this is your speed
      // print('speedInMps = $speedInMps');
      setState(() {
        speed = double.parse('${speedInMps}');
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
              // _showDialog(context);
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
                        "โหมดการขับขี่เริ่มต้น",
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
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      child: Column(
                        children: [
                          speed != null
                              ? Text(
                                  '${(speed! * 3.7).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontFamily: 'ethnocentric',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  " ",
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontFamily: 'ethnocentric',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                          Expanded(
                            child: Text(
                              "กิโลเมตร/ชม.",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Text(
                              "โหมดการขับขี่เริ่มต้น",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Kanit',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "จะไม่มีการปรับแต่งค่าใดระหว่างการใช้งาน",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('lib/img/icon1.2.png'),
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
                    if (characteristic != null) {
                      widget.characteristic!.write(utf8.encode('RY08#'));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => page9(
                                    characteristic: widget.characteristic,
                                    value1: 0,
                                  )));
                    }
                  },
                  icon: Image.asset('lib/img/icon9.png'),
                  iconSize: 70,
                ),
                IconButton(
                  onPressed: () {
                    // if (characteristic != null) {
                    //   // widget.characteristic!.write(utf8.encode('RY08#'));
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
