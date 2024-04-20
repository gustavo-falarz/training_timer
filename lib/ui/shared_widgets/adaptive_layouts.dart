import 'package:flutter/material.dart';

import '../../dimens.dart';


class AdaptiveFillContainer extends StatelessWidget {
  const AdaptiveFillContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: kMaxColumnWidth),
        child: child,
      ),
    );
  }
}
