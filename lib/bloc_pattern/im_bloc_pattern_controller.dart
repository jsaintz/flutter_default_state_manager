import 'dart:async';
import 'dart:math';

import 'package:flutter_default_state_manager/bloc_pattern/Imc_state_loading.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_state_error.dart';

class ImBlocPatternController {
  final _imcStreamController = StreamController<ImcState>.broadcast()..add(ImcState(imc: 0));
  Stream<ImcState> get imcOut => _imcStreamController.stream;

  Future<void> countImc({required double peso, required double altura}) async {
    final imc = peso / pow(altura, 2);
    try {
      _imcStreamController.add(ImcStateLoading(imc: 0));
      await Future.delayed(const Duration(seconds: 1));

      _imcStreamController.add(ImcState(imc: imc));
    } catch (e) {
      _imcStreamController.add(ImcStateError(imc: imc, message: 'Erro ao calcular IMC'));
    }
  }

  void dispose() {
    _imcStreamController.close();
  }
}
