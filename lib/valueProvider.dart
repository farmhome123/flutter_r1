import 'package:flutter/material.dart';

class valueProvider with ChangeNotifier {
  double? value1;
  double? value2;
  notifyListeners();
  // สร้างฟังก์ชันการนับ counter
  increment(value1PRO, value2PRO) {
    value1 = value1PRO;
    value2 = value2PRO;
    notifyListeners();
  }
}