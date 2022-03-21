import 'dart:math';

import 'package:flutter/widgets.dart';

class ImChangeNotifierController extends ChangeNotifier {
  double imc = 0.0;

  Future<void> countImc({required double peso, required double altura}) async {
    imc = 0;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    imc = peso / pow(altura, 2);
    notifyListeners();
  }
}
