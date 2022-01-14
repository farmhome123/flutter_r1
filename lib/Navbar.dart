import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torqueair/page1.dart';
import 'package:torqueair/page10.dart';
import 'package:torqueair/reset.dart';
import 'package:torqueair/settingble.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);
  void _showDialogStart(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ตั้งค่าเริ่มต้นการใช้งาน',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'Kanit'),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/img/resetpage.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget cancelButton = FlatButton(
          child: Text("ยกเลิก"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        Widget continueButton = FlatButton(
          child: Text("ตกลง"),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('uidble', '');
            prefs.setString('passwordCode', '1234');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => page10(
                          characteristic: null,
                          value1: '',
                        )));
          },
        );
        return AlertDialog(
          title: new Text("ล้างค่าการเชื่อมต่อ"),
          content: new Text(
            'ต้องการล้างค่าการเชื่อมต่อหรือไม่ ?',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontFamily: 'Kanit'),
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _launchURLBrowser(String url) async {
      // const url = 'https://www.raceone.net';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // throw 'Could not launch $url';
      }
    }

    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: 300,
              height: 200,
              child: Image.asset('logo/logoz.png'),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _showDialogStart(context);
                },
                child: Text(
                  'ตั้งค่าเริ่มต้นการใช้งาน',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingBle()));
                },
                child: Text(
                  'เชื่อมต่ออุปกรณ์',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _launchURLBrowser('https://www.raceone.net/manual');
                },
                child: Text(
                  'คู่มือการใช้งาน',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  // _launchURLBrowser('https://www.raceone.net');
                  _showDialog(context);
                },
                // ต้องการคืนค่าโรงงาน
                //  ยืนยัน    ยกเลิก
                child: Text(
                  'ล้างค่าการเชื่อมต่อ',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                  title: TextButton(
                onPressed: () {
                  _launchURLBrowser('https://www.raceone.net/contactus');
                },
                child: Text(
                  'ติดต่อเรา',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Kanit'),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
