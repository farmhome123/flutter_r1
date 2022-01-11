import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _launchURLBrowser() async {
    const url = 'https://www.raceone.net';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
              margin: EdgeInsets.only(right: 20,left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                title: TextButton(onPressed: _launchURLBrowser,
                 child: Text(
                  'ตั้งค่าเริ่มต้นการใช้งาน',
                  style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: 'Kanit'),
                ),)
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20,left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                title: TextButton(onPressed: _launchURLBrowser,
                 child: Text(
                  'เชื่อมต่ออุปกรณ์',
                  style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: 'Kanit'),
                ),)
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20,left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                title: TextButton(onPressed: _launchURLBrowser,
                 child: Text(
                  'คู่มือการใช้งาน',
                  style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: 'Kanit'),
                ),)
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20,left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                title: TextButton(onPressed: _launchURLBrowser,
                 child: Text(
                  'คืนค่าโรงงาน',
                  style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: 'Kanit'),
                ),)
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20,left: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: ListTile(
                title: TextButton(onPressed: _launchURLBrowser,
                 child: Text(
                  'ติดต่อเรา',
                  style: TextStyle(color: Colors.white,fontSize: 15,fontFamily: 'Kanit'),
                ),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
