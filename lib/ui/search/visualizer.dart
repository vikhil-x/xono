import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MusicVisualizer extends StatefulWidget {
  const MusicVisualizer({super.key});

  @override
  State<MusicVisualizer> createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer> {
  final int barCount = 3;
  final random = Random();
  late List<double> heights;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    heights = List.generate(barCount, (_) => randomHeight());
    timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() => heights = List.generate(barCount, (_) => randomHeight()));
    });
  }

  double randomHeight() => random.nextDouble() * 100;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(barCount, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 5,
          height: heights[i],
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
