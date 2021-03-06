import 'dart:convert' show utf8;
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
  final BluetoothDevice? device;
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  const page1(
      {Key? key,
      this.valueTx,
      required this.characteristic,
      required this.device})
      : super(key: key);

  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  BluetoothCharacteristic? characteristic;
  double? speed;
  List<int>? speedAlert;
  bool statusconnect = false;
  int? sumValue;
  Random random = new Random();

  void showAlertBrake() {
    Flushbar(
      title: "เกิดการเบรคกระทันหัน",
      message: "เกิดการเบรคกระทันหัน",
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
      padding: EdgeInsets.all(8.0),
    ).show(context);
  }

  _sendSMS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _phoneSms = prefs.get('phone');
    final url = Uri.parse("https://torqueair.komkawila.com/$_phoneSms");
    var data = {"message": "เกิดการเบรคกระทันหัน"};

    try {
      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        print('_phoneSms success');
      } else {
        print('_phoneSms faild');
      }
    } catch (e) {
      print(e);
    }
  }

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
    speedAlert = [];
    checkPermission();
    print('โหมด  AI SPORT');
    print('send to esp RY0102#');
    setState(() {
      setState(() {
        characteristic = widget.characteristic;
      });
    });
    statusconnecttion();
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
              content: Text(
                  'กรุณาเปิด Localtion Service เพื่อเข้าใช้งานตำแหน่งเพื่ออ่านค่าความเร็วรถยนต์'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                    //await Geolocator.openLocationSettings();
                    // exit(0);
                    // Find LatLang
                    Navigator.pop(context);
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
              content: Text(
                  'กรุณาเปิด Localtion Service เพื่อเข้าใช้งานตำแหน่งเพื่ออ่านค่าความเร็วรถยนต์'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                    // await Geolocator.openLocationSettings();
                    // exit(0);
                    // Find LatLang
                    Navigator.pop(context);
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
          content: Text(
              'กรุณาเปิด Localtion Service เพื่อเข้าใช้งานตำแหน่งเพื่ออ่านค่าความเร็วรถยนต์'),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                //await Geolocator.openLocationSettings();
                // exit(0);
                // Find LatLang
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<Null> findSpeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _phoneSms = prefs.get('phone');
    final _phoneSmsmain = prefs.get('phonemain');
    if (_phoneSms != null && _phoneSmsmain != null) {
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
            // accuracy: LocationAccuracy.high,
            // distanceFilter: 100,
            // pauseLocationUpdatesAutomatically: true,

            );
      } else {
        print('locationSettings orter');
        locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
      }
      int count = 0;
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((position) async {
        var speedInMps = await position.speed; // this is your speed
        // print('speedInMps = $speedInMps');
        var speedTest = double.parse(speedInMps.toString());
        setState(() {
          speed = double.parse('${speedInMps}');
        });

        if (speed != null) {
          int randomNumber = random.nextInt(90) + 10;
          print(' ${(speedTest).toStringAsFixed(0)} speedTest');
          // print('random speed ==>$randomNumber');

          if (speedAlert!.length < 4) {
            // if (speedTest > 0) {
            //   speedAlert!.add((speedTest).toInt());
            // }
            speedAlert!.add((randomNumber));
            print("speedAlert!.length ==> ${speedAlert!.length}");
            if (speedAlert!.length == 4) {
              print('speedAlert![${speedAlert!.length}] ===> ${speedAlert!}');
              int sum = speedAlert!.first - speedAlert!.last;
              print('speed 1 - 4 == > ${sum}');
              setState(() {
                sumValue = sum;
              });
              if (sum >= 10) {
                print('แจ้งเตือนแบกกระทันหัน');
                // showAlertBrake();
                _modalCallPhone();
                _sendSMS();
                setState(() {});
              } else {
                speedAlert!.removeAt(0);
              }
            }
          }
        }
      });
    } else {
      print('ไม่มีเบอร์SMS');
      showAlertBar();
    }
  }

  void _modalCallPhone() {
    final _bildListTile = (
      IconData icon,
      String title,
    ) =>
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.pop(context);
            // _pickImage(imageSource);
          },
        );
    showBottomSheet(
      backgroundColor: Colors.blue[50],
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _bildListTile(
            Icons.photo_camera,
            "Take a picture from camera",
          ),
          _bildListTile(
            Icons.photo_library,
            "Take a picture from gallery",
          ),
        ],
      ),
    );
  }

  void showAlertBar() {
    Flushbar(
      title: "คุณยังไม่ได้เพิ่มเบอร์ SMS",
      message: "กรุณาเพิ่มเบอร์มือถือ",
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
      padding: EdgeInsets.all(8.0),
    ).show(context);
  }

  void statusconnecttion() async {
    if (widget.device != null) {
      widget.device!.state.listen((status) {
        print('######### -------- Status ble ---- > ${status}');
        if (status == BluetoothDeviceState.connected) {
          print('connected !!!!!!');
          setState(() {
            statusconnect = true;
          });
        } else {
          print('disconnected !!!!!!');
          setState(() {
            statusconnect = false;
          });
          if (widget.device != null) {
            widget.device!.disconnect();
          }
        }
      });
    }
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
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              IconButton(
                icon: Icon(
                  Icons.bluetooth,
                  size: 30,
                ),
                onPressed: () {
                  // _showDialog(context);

                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: SettingBle(),
                      ));
                },
              ),
              Icon(Icons.circle,
                  color: statusconnect == false ? Colors.red : Colors.green,
                  size: 10),
            ],
          ),
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
                      // height: 200,
                      height: 300,
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
                          Expanded(
                            child: Text(
                              "speedAlert $speedAlert",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Kanit',
                                  color: Colors.deepOrange),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "sumValue $sumValue",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Kanit',
                                  color: Colors.deepOrange),
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page2(
                                characteristic: widget.characteristic,
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page3(
                                value: '0',
                                characteristic: widget.characteristic,
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page4(
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
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page5(
                                characteristic: widget.characteristic,
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page6(
                                characteristic: widget.characteristic,
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page7(
                                characteristic: widget.characteristic,
                                value: 0,
                                value1: 0,
                                value2: 0,
                                value3: 0,
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page8(
                                characteristic: widget.characteristic,
                                value1: 0,
                                value2: 0,
                                device: widget.device),
                          ));
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
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: page9(
                                characteristic: widget.characteristic,
                                value1: 0,
                                device: widget.device),
                          ));
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
                    print('PageTransition');
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: page10(
                              characteristic: widget.characteristic,
                              value1: '',
                              device: widget.device),
                        ));
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