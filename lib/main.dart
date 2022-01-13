import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:torqueair/splash.dart';
import 'package:torqueair/valueProvider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<valueProvider>(
        create: (_) => valueProvider(),
      ),
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setPassword();
  }

  _setPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statuslock', 'false');
    var statuslock = prefs.getString('statuslock');
    print(statuslock);
    if (statuslock == false) {
      prefs.setString('passwordCode', '1234');
      setState(() {
        prefs.setString('statuslock', 'true');
      });
    }
    var code = prefs.getString('passwordCode');
    print('Codepassword : ${code}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Splash(),
    );
  }
}
