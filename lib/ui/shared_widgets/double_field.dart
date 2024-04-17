import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_timer/ui/shared_widgets/icons.dart';

import '../../dimens.dart';

class DoubleField extends StatelessWidget {
  final Function onTextChangedMin;
  final Function onTextChangedSec;
  final String label;
  final int initialValueMin;
  final int initialValueSec;

  DoubleField({
    super.key,
    required this.label,
    required this.onTextChangedMin(int value),
    required this.onTextChangedSec(int value),
    required this.initialValueMin,
    required this.initialValueSec,
  });

  final _controllerMin = TextEditingController();
  final _controllerSec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controllerMin.text = initialValueMin.toString();
    _controllerSec.text = initialValueSec.toString();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: marginTopTimers),
          child: Center(
            child: Text(
              label,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const DecIcon(),
                  onPressed: () {
                    onPressDec();
                  },
                ),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _controllerMin,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(counter: SizedBox.shrink()),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    onTextChangedMin(int.parse(text));
                  }
                },
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  ":",
                ),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _controllerSec,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(counter: SizedBox.shrink()),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    onTextChangedSec(int.parse(text));
                  }
                },
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const IncIcon(),
                  onPressed: () {
                    onPressInc();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  onPressDec() {
    var value = int.parse(_controllerMin.text);
    if (value > 0) {
      value = value - 1;
      _controllerMin.text = value.toString();
      onTextChangedMin(value);
    }
  }

  onPressInc() {
    var value = int.parse(_controllerMin.text);
    value = value + 1;
    _controllerMin.text = value.toString();
    onTextChangedMin(value);
  }
}
