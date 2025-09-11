import 'dart:math';

import 'package:flutter/material.dart';
import 'lyric_widget.dart';

class LyricWidgetToggle extends StatefulWidget {
  const LyricWidgetToggle({super.key});

  @override
  State<LyricWidgetToggle> createState() => _LyricWidgetToggleState();
}

class _LyricWidgetToggleState extends State<LyricWidgetToggle> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: expanded
              ? const Icon(Icons.keyboard_double_arrow_down)
              : const Icon(Icons.keyboard_double_arrow_up),
        ),
        expanded ? const LyricWidget() : const SizedBox.shrink(),
      ],
    );
  }
}
