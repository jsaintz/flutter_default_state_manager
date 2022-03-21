import 'package:flutter_default_state_manager/bloc_pattern/Imc_state_loading.dart';
import 'package:flutter_default_state_manager/bloc_pattern/im_bloc_pattern_controller.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_state_error.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_default_state_manager/widgets/imc_gauge.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class ImcBlocPatternPage extends StatefulWidget {
  const ImcBlocPatternPage({Key? key}) : super(key: key);

  @override
  _ImcBlocPatternPageState createState() => _ImcBlocPatternPageState();
}

class _ImcBlocPatternPageState extends State<ImcBlocPatternPage> {
  final controller = ImBlocPatternController();
  final pesoEc = TextEditingController();
  final alturaEc = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    pesoEc.dispose();
    alturaEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imc Bloc Pattern'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<ImcState>(
                    stream: controller.imcOut,
                    builder: (context, snapshot) {
                      double imc = snapshot.data?.imc ?? 0;
                      return ImcGauge(imc: imc);
                    }),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<ImcState>(
                    stream: controller.imcOut,
                    builder: (context, snapshot) {
                      final dataValue = snapshot.data;
                      if (dataValue is ImcStateLoading) return const Center(child: CircularProgressIndicator());

                      if (dataValue is ImcStateError) return Text(dataValue.message);

                      return const SizedBox.shrink();
                    }),
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: pesoEc,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'pt_BR',
                      symbol: '',
                      turnOffGrouping: true,
                      decimalDigits: 2,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso Obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: alturaEc,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Altura'),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'pt_BR',
                      symbol: '',
                      turnOffGrouping: true,
                      decimalDigits: 2,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura Obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      var formValid = formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        var formatter = NumberFormat.simpleCurrency(
                          locale: 'pt_Br',
                          decimalDigits: 2,
                        );
                        double peso = formatter.parse(pesoEc.text) as double;
                        double altura = formatter.parse(alturaEc.text) as double;
                        controller.countImc(peso: peso, altura: altura);
                      }
                    },
                    child: const Text('Calcular IMC'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
