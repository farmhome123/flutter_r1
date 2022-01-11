import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torqueair/page1.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Splash(),
    );
  }
}

class Page1 extends StatefulWidget {
  Page1({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return page1(
      characteristic: null,
    );
  }
}
