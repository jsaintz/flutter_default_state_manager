import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';

class ImcStateError extends ImcState {
  String message;
  ImcStateError({required double imc, required this.message}) : super(imc: imc);
}
