import 'package:flutter/material.dart';

class DecIcon extends StatelessWidget {
  const DecIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.indeterminate_check_box);
  }
}

class IncIcon extends StatelessWidget {
  const IncIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.add_box);
  }
}
