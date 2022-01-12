import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:torqueair/Navbar.dart';
import 'package:torqueair/page1.dart';
import 'package:torqueair/page2.dart';
import 'package:torqueair/page3.dart';
import 'package:torqueair/page4.dart';
import 'package:torqueair/page5.dart';
import 'package:torqueair/page6.dart';
import 'package:torqueair/page7.dart';
import 'package:torqueair/page8.dart';
import 'package:torqueair/page9.dart';
import 'package:torqueair/settingble.dart';

const storedPasscode = '1234';

class page10 extends StatefulWidget {
  final List<int>? valueTx;
  final BluetoothCharacteristic? characteristic;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;
  const page10({
    Key? key,
    this.valueTx,
    required this.characteristic,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
  }) : super(key: key);

  @override
  _page10State createState() => _page10State();
}

class _page10State extends State<page10> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;
  String? value1;
  String? value2;
  String? value3;
  String? value4;
  String? value5;
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
                        "โหมดล็อคกันขโมย",
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
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'คุณ${isAuthenticated ? 'ปลดล็อคแล้ว' : 'ยังไม่ล็อคกันขโมย'}',
                      style: TextStyle(color: Colors.white),
                    ),
                    _defaultLockScreenButton(context),
                  ],
                ),
              ),
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
                  onPressed: () {         if (characteristic != null) {
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
                  onPressed: () {         if (characteristic != null) {
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
                  onPressed: () {         if (characteristic != null) {
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
                  onPressed: () {         if (characteristic != null) {
                    widget.characteristic!.write(utf8.encode('RY06#'));}
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
                  onPressed: () {         if (characteristic != null) {
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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => page10(
                    //               characteristic: widget.characteristic,
                    //               value1: '',
                    //               value2: '',
                    //               value3: '',
                    //               value4: '',
                    //               value5: '',
                    //             )));
                  },
                  icon: Image.asset('lib/img/icon10.1.png'),
                  iconSize: 70,
                ),
              ],
            ),
           ],
        ),
      ),
    );
  }

  _defaultLockScreenButton(BuildContext context) => MaterialButton(
        color: Colors.grey,
        child: Text('เปิดหน้ารหัสผ่าน'),
        onPressed: () {
          _showLockScreen(
            context,
            opaque: false,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _showLockScreen(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(

            title: Text(
              'โปรดใส่รหัสผ่านของคุณ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 28, fontFamily: 'Kanit'),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black,
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
            bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: TextButton(
            child: Text(
              "Reset passcode",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            onPressed: _resetAppPassword,
            // splashColor: Colors.white.withOpacity(0.4),
            // highlightColor: Colors.white.withOpacity(0.2),
            // ),
          ),
        ),
      );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }
}
